#include "controller.hpp"

controller* controller::instance() {
    return new controller();
}

void controller::upload_view(const std::string& file_name) {
    this->__model_view.add_view(this->__upload_manager.upload_model(file_name));
}

void controller::delete_view(size_t index) {
    this->__model_view.delete_view(index);
}

void controller::add_model(size_t index) {
    this->__scene.add_model(const_cast<model*>(&this->__model_view.get_model(index)));
}

void controller::remove_model(size_t index) {
    this->__scene.remove_model(index);
}

void controller::add_camera() {
    this->__scene.add_camera(new camera());
}

void controller::remove_camera(size_t index) {
    this->__scene.remove_camera(index);
}

void controller::transform_model(base_transformations* transformation, size_t index) {
    this->__model_manager.transform(this->__scene, transformation, index);
}
