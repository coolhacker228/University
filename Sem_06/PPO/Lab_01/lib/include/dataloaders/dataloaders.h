#pragma once

#include <QSharedPointer>

#include <common/route.h>

class GpxDataLoader
{
    Q_DISABLE_COPY(GpxDataLoader)

public:
    GpxDataLoader() = default;
    ~GpxDataLoader() = default;

    static void load(const QString &fileName, QSharedPointer<Route> route);
};
