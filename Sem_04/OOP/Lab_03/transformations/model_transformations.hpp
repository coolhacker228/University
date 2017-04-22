#ifndef MODEL_TRANSFORMATIONS_HPP
#define MODEL_TRANSFORMATIONS_HPP

#include "base_transformations.hpp"
#include "objects/model.hpp"

class model_transformations : public base_transformations {
    public:
        model_transformations(transformation_interface& interface) : base_transformations(interface) {}
        model_transformations(model_transformations&);
        model_transformations(const model_transformations&);
        ~model_transformations() = default;

        void transform(scene_object*& object) override {
            if (object->visible()) {
                model* m = reinterpret_cast<model*>(object);

                for (size_t i = 0; i < m->points.size(); ++i) {
                    m->points[i].set_second(multiply(transformation_matrix, m->points[i].get_second()));
                }
            }
        }
};

#endif // MODEL_TRANSFORMATIONS_HPP
