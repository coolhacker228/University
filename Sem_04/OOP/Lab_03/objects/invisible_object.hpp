#ifndef INVISIBLE_OBJECT_HPP
#define INVISIBLE_OBJECT_HPP

#include "scene_object.hpp"

class invisible_object : public scene_object {
    public:
        explicit invisible_object() = default;
        invisible_object(invisible_object&) = delete;
        invisible_object(const invisible_object&) = delete;
        virtual ~invisible_object() = default;

        virtual void transform() = 0;

        bool visible() {
            return false;
        }
};

#endif // INVISIBLE_OBJECT_HPP
