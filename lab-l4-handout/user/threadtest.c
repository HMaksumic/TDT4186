#include "kernel/types.h"
#include "kernel/riscv.h"
#include "user.h"

static struct thread *target;
static int target_value = 42;
static int stolen_join;
static int joined_value;
static int completion_fd;

static void *finish_later(void *arg)
{
    tyield();
    return &target_value;
}

static void *try_second_join(void *arg)
{
    tyield();
    stolen_join = tjoin(target->tid, 0, 0);
    return 0;
}

static void *join_target(void *arg)
{
    assert(tjoin(target->tid, &joined_value, sizeof(joined_value)) == 0);
    return 0;
}

static void *complete_worker(void *arg)
{
    char token = (uint64)arg;

    for (int i = 0; i < 3; i++)
        tyield();
    assert(write(completion_fd, &token, 1) == 1);
    return 0;
}

static void *complete_parent(void *arg)
{
    struct thread *child;
    char token = 'B';

    // This child is created after main has returned to the entry-point wrapper.
    tyield();
    tcreate(&child, 0, complete_worker, (void *)'C');
    assert(tjoin(child->tid, 0, 0) == 0);
    assert(write(completion_fd, &token, 1) == 1);
    return 0;
}

static void check_join_ownership(void)
{
    struct thread *contender;
    struct thread *joiner;
    struct thread_attr attr = {PGSIZE, sizeof(int)};

    stolen_join = 0;
    joined_value = 0;
    tcreate(&target, &attr, finish_later, 0);
    tcreate(&contender, 0, try_second_join, 0);
    tcreate(&joiner, 0, join_target, 0);
    assert(tjoin(joiner->tid, 0, 0) == 0);
    assert(tjoin(contender->tid, 0, 0) == 0);
    assert(stolen_join != 0);
    assert(joined_value == target_value);

    // More creations than available slots verify that joined workers are freed.
    for (int i = 0; i < 40; i++)
    {
        int value = 0;
        tcreate(&target, &attr, finish_later, 0);
        assert(tjoin(target->tid, &value, sizeof(value)) == 0);
        assert(value == target_value);
    }
    assert(tjoin(-1, 0, 0) != 0);
    assert(tjoin(twhoami(), 0, 0) != 0);
}

static void check_main_return(void)
{
    int fds[2];
    int status = -1;
    int seen = 0;
    char token;

    assert(pipe(fds) == 0);
    int pid = fork();
    assert(pid >= 0);
    if (pid == 0)
    {
        char fdarg[2] = {'0' + fds[1], 0};
        char *argv[] = {"threadtest", "return", fdarg, 0};
        close(fds[0]);
        assert(fds[1] < 10);
        exec(argv[0], argv);
        exit(1);
    }

    close(fds[1]);
    while (read(fds[0], &token, 1) == 1)
    {
        assert(token >= 'A' && token <= 'C');
        int bit = 1 << (token - 'A');
        assert((seen & bit) == 0);
        seen |= bit;
    }
    close(fds[0]);
    assert(wait(&status) == pid);
    assert(status == 42);
    assert(seen == 7);
}

int main(int argc, char *argv[])
{
    if (argc == 3 && strcmp(argv[1], "return") == 0)
    {
        struct thread *worker;
        completion_fd = atoi(argv[2]);
        tcreate(&worker, 0, complete_worker, (void *)'A');
        tcreate(&worker, 0, complete_parent, 0);
        tsched();
        return 42;
    }

    check_join_ownership();
    check_main_return();
    printf("thread regression tests passed\n");
    return 0;
}
