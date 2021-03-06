#include "pthread_impl.h"
#include <threads.h>

void *lthread_getspecific(pthread_key_t key);

static void *__pthread_getspecific(pthread_key_t k)
{
        return lthread_getspecific(k);
}

weak_alias(__pthread_getspecific, pthread_getspecific);
weak_alias(__pthread_getspecific, tss_get);
