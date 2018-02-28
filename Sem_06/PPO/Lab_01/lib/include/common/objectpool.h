#pragma once

#include <QQueue>
#include <QSharedPointer>
#include <QMutex>
#include <QWaitCondition>

template <class T>
class ObjectPool
{
    const static int MAX_POOL_SIZE = 10;

public:
    ObjectPool()
    {

    }

    ~ObjectPool()
    {

    }

    QSharedPointer<T> take()
    {
        QMutexLocker guard(&m_mutex);

        while (m_pool.empty()) {
            m_condition.wait(&m_mutex);
        }

        auto ptr = m_pool.front();
        m_pool.removeFirst();

        return ptr;
    }

    void put(QSharedPointer<T> ptr)
    {
        {
            QMutexLocker guard(&m_mutex);
            m_pool.append(ptr);
        }
        m_condition.wakeOne();
    }

    bool isEmpty()
    {
        return m_pool.empty();
    }

private:
    QMutex m_mutex;
    QWaitCondition m_condition;
    QQueue<QSharedPointer<T>> m_pool;
};