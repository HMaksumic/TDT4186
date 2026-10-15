#include "kernel/types.h"
#include "kernel/riscv.h"
#include "user.h"

#define LIB_PREFIX "[UTHREAD]: "
#define ulog() printf("%s%s\n", LIB_PREFIX, __FUNCTION__)

#define MAX_THREADS 16

static struct thread threads[MAX_THREADS];
static struct thread *current_thread;
static uint8 threadlib_init_done;

static void threadlib_init(void);
static struct thread *find_thread(int tid);
static struct thread *next_runnable_thread(void);
static void thread_bootstrap(void) __attribute__((noreturn));
static void thread_exit(void *retval) __attribute__((noreturn));
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
    {
        memset(&threads[i], 0, sizeof(threads[i]));
        threads[i].tid = i;
        threads[i].state = UNUSED;
    }

    current_thread = &threads[0];
    current_thread->state = RUNNING;
    threadlib_init_done = 1;
}

static struct thread *
find_thread(int tid)
{
    if (tid < 0 || tid >= MAX_THREADS)
    {
        return 0;
    }

    if (threads[tid].state == UNUSED)
    {
        return 0;
    }

    return &threads[tid];
}

static struct thread *
next_runnable_thread(void)
{
    int start = current_thread ? current_thread->tid : 0;

    for (int offset = 1; offset <= MAX_THREADS; offset++)
    {
        int idx = (start + offset) % MAX_THREADS;

        if (threads[idx].state == RUNNABLE)
        {
            return &threads[idx];
        }
    }

    if (current_thread && current_thread->state == RUNNABLE)
    {
        return current_thread;
    }

    return 0;
}

static void
thread_bootstrap(void)
{
    struct thread *thread = current_thread;
    void *retval = 0;

    if (thread)
    {
        retval = thread->func(thread->arg);
    }

    thread_exit(retval);
}

static void
thread_exit(void *retval)
{
    struct thread *thread = current_thread;

    if (thread->res_size > 0 && thread->result && retval)
    {
        memmove(thread->result, retval, thread->res_size);
    }

    thread->state = EXITED;
    if (thread->joiner && thread->joiner->state == SLEEPING)
    {
        thread->joiner->state = RUNNABLE;
    }

    tsched();
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
    uint8 tid = thread->tid;

    if (thread->stack)
    {
        free(thread->stack);
    }
    if (thread->result)
    {
        free(thread->result);
    }

    memset(thread, 0, sizeof(*thread));
    thread->tid = tid;
    thread->state = UNUSED;
}

void tsched()
{
    struct thread *prev;
    struct thread *next;

    threadlib_init();
    prev = current_thread;
    if (prev->state == RUNNING)
    {
        prev->state = RUNNABLE;
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
        exit(-1);
    }

    if (next == prev)
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
    next->state = RUNNING;
    tswtch(&prev->tcontext, &next->tcontext);
}

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
    {
        if (attr->stacksize)
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == UNUSED)
        {
            new_thread = &threads[i];
            break;
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
        exit(-1);
    }

    memset(new_thread, 0, sizeof(*new_thread));
    new_thread->tid = new_thread - threads;
    new_thread->func = func;
    new_thread->arg = arg;
    new_thread->stacksize = stacksize;
    new_thread->res_size = res_size;
    new_thread->state = RUNNABLE;

    new_thread->stack = malloc(stacksize + 16);
    if (new_thread->stack == 0)
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
    {
        new_thread->result = malloc(res_size);
        if (new_thread->result == 0)
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
    new_thread->tcontext.sp = stack_top;

    if (thread)
    {
        *thread = new_thread;
    }
}

int tjoin(int tid, void *status, uint size)
{
    struct thread *target;

    threadlib_init();
    if (current_thread->tid == tid)
    {
        return -1;
    }

    target = find_thread(tid);
    if (target == 0)
    {
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
    {
        return -1;
    }
    target->joiner = current_thread;

    while (target->state != EXITED)
    {
        current_thread->state = SLEEPING;
        tsched();
    }

    if (status && size && target->result)
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
    }

    reclaim_thread(target);
    return 0;
}

void tyield()
{
    threadlib_init();
    if (current_thread->state == RUNNING)
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
}

uint8 twhoami()
{
    threadlib_init();
    return current_thread->tid;
}

void twaitall(void)
{
    threadlib_init();

    for (;;)
    {
        int unfinished = 0;
        int runnable = 0;

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
                if (threads[i].state == RUNNABLE)
                {
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
        {
            break;
        }
        if (!runnable)
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
        {
            reclaim_thread(&threads[i]);
        }
    }
}
