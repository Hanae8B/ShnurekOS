
#include <stdarg.h>

// Assume you have serial_print implemented somewhere
extern void serial_print(const char* msg);

static void serial_putc(char c) {
    // Implement this to send a single char to serial port
    // For example (if using serial_print):
    char buf[2] = {c, '\0'};
    serial_print(buf);
}

int puts(const char* str) {
    while (*str) {
        serial_putc(*str++);
    }
    serial_putc('\n');
    return 0;
}

// Simple strlen
static int strlen(const char* s) {
    int len = 0;
    while (s[len]) len++;
    return len;
}

// Minimal printf supporting %s and %d only
int printf(const char* fmt, ...) {
    va_list args;
    va_start(args, fmt);

    for (; *fmt; fmt++) {
        if (*fmt == '%') {
            fmt++;
            if (*fmt == 's') {
                const char* s = va_arg(args, const char*);
                while (*s) serial_putc(*s++);
            } else if (*fmt == 'd') {
                int num = va_arg(args, int);
                char buf[16];
                int i = 0, neg = 0;
                if (num < 0) {
                    neg = 1;
                    num = -num;
                }
                do {
                    buf[i++] = '0' + (num % 10);
                    num /= 10;
                } while (num > 0);
                if (neg) buf[i++] = '-';
                while (i--) serial_putc(buf[i]);
            } else {
                serial_putc(*fmt);
            }
        } else {
            serial_putc(*fmt);
        }
    }

    va_end(args);
    return 0;
}

// Minimal strcmp
int strcmp(const char* a, const char* b) {
    while (*a && (*a == *b)) {
        a++; b++;
    }
    return (unsigned char)*a - (unsigned char)*b;
}

// Minimal strncpy
char* strncpy(char* dest, const char* src, unsigned int n) {
    unsigned int i;
    for (i = 0; i < n && src[i]; i++) {
        dest[i] = src[i];
    }
    for (; i < n; i++) {
        dest[i] = '\0';
    }
    return dest;
}

// Minimal strstr (find substring)
char* strstr(const char* haystack, const char* needle) {
    if (!*needle) return (char*)haystack;
    for (; *haystack; haystack++) {
        const char* h = haystack;
        const char* n = needle;
        while (*h && *n && (*h == *n)) {
            h++; n++;
        }
        if (!*n) return (char*)haystack;
    }
    return 0;
}

// Minimal strcspn - length of segment not containing characters in reject
unsigned int strcspn(const char* s, const char* reject) {
    unsigned int count = 0;
    while (*s) {
        const char* r = reject;
        while (*r) {
            if (*s == *r) return count;
            r++;
        }
        s++;
        count++;
    }
    return count;
}

// Minimal fgets - very basic, reads from a provided function, or stub here
char* fgets(char* buf, int size, void* stream) {
    // Since you probably don't have stdin, either implement your own or stub
    // For now, just return NULL to avoid linker errors
    (void)buf; (void)size; (void)stream;
    return NULL;
}
