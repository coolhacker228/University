/*
MIT License

Copyright (c) 2017 Vahan Aghajanyan <vahancho@gmail.com>
Copyright (c) 2018 Andrey Kamakin <a.kamakin@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#ifndef POLYLINEENCODER_H
#define POLYLINEENCODER_H

#include <QPointF>

//! Implements Google's polyline compression algorithm.
/*!
  For more details refer to the algorithm definition at
  https://developers.google.com/maps/documentation/utilities/polylinealgorithm
*/
class PolylineEncoder
{
public:
    using Polyline = QVector<QPointF>;

    //! Adds new point with the given \p latitude and \p longitude for encoding.
    void addPoint(qreal latitude, qreal longitude);

    //! Encode the polyline according to the defined compression algorithm.
    /*!
    \return The encoded polyline as string.
    */
    QString encode() const;

    //! Returns the existing polyline.
    const Polyline &polyline() const;

    //! Clears the list of polyline.
    void clear();

    //! Returns the result of encoding of the given polyline.
    static QString encode(const Polyline &polyline);

    //! Returns polyline decoded from the given \p coordinates string.
    static Polyline decode(const QString &coordinates);

private:
    //! Encodes a single value according to the compression algorithm.
    static QString encode(qreal value);

    //! Decodes the current decimal value out of string.
    static qreal decode(const QString &coords, size_t &i);

    //! Store the polyline - the list of points.
    Polyline m_polyline;
};

#endif // POLYLINEENCODER_H
