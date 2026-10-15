// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

uint64 MAX_PAGES = 0;
uint64 FREE_PAGES = 0;

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run
{
    struct run *next;
};

int page_refs[(PHYSTOP - KERNBASE) / PGSIZE];

struct
{
    struct spinlock lock;
    struct run *freelist;
} kmem;

static int
page_slot(void *pa)
{
    int slot;

    slot = ((uint64)pa - KERNBASE) / PGSIZE;
    return slot;
}

void kinit()
{
    initlock(&kmem.lock, "kmem");
    freerange(end, (void *)PHYSTOP);
    MAX_PAGES = FREE_PAGES;
}

void freerange(void *pa_start, void *pa_end)
{
    char *p;
    p = (char *)PGROUNDUP((uint64)pa_start);
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    {
        page_refs[page_slot(p)] = 1;
        kfree(p);
    }
}

void
kaddref(void *pa)
{
    int slot;

    slot = page_slot(pa);
    acquire(&kmem.lock);
    page_refs[slot] = page_refs[slot] + 1;
    release(&kmem.lock);
}

int
kgetref(void *pa)
{
    int ref;
    int slot;

    slot = page_slot(pa);
    acquire(&kmem.lock);
    ref = page_refs[slot];
    release(&kmem.lock);
    return ref;
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    struct run *r;
    int slot;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
        panic("kfree");

    slot = page_slot(pa);
    acquire(&kmem.lock);
    if (page_refs[slot] < 1)
        panic("kfree");
    page_refs[slot] = page_refs[slot] - 1;
    if (page_refs[slot] > 0)
    {
        release(&kmem.lock);
        return;
    }
    if (MAX_PAGES != 0)
        assert(FREE_PAGES < MAX_PAGES);
    memset(pa, 1, PGSIZE);
    r = (struct run *)pa;
    r->next = kmem.freelist;
    kmem.freelist = r;
    FREE_PAGES++;
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    struct run *r;
    int slot;

    acquire(&kmem.lock);
    r = kmem.freelist;
    if (r)
    {
        kmem.freelist = r->next;
        slot = page_slot(r);
        page_refs[slot] = 1;
        FREE_PAGES--;
    }
    release(&kmem.lock);

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    return (void *)r;
}
