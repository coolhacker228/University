//
// Created by lieroz on 30.11.16.
//

#ifndef LAB_09_DEQUEUE_H
#define LAB_09_DEQUEUE_H

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MULTIPLIER_COEF 2
#define compare(a, b) a < b ? a : b

typedef struct {
	int* base;
	int* next_item;

	int self_size;
	int base_size;
} Dequeue;

Dequeue* Constructor();
void Destructor(Dequeue*);

void push_front(Dequeue*, int);
int pop_front(Dequeue*);

void push_back(Dequeue*, int);
int pop_back(Dequeue*);

int size(Dequeue*);
bool empty(Dequeue*);

#endif //LAB_09_DEQUEUE_H
