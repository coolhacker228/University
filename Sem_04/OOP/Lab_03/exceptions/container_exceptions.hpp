#ifndef CONTAINER_EXCEPTIONS_HPP
#define CONTAINER_EXCEPTIONS_HPP

#include <string>

#include "base_exception.hpp"

class base_container_exception : public base_exception {
    protected:
        std::string message;

    public:
        explicit base_container_exception() = default;

        explicit base_container_exception(const char* message) {
            this->message = message;
        }

        explicit base_container_exception(std::string& message) {
            this->message = message;
        }

        virtual const char* what() const noexcept {
            return message.empty() ? "container::(base exception)!" : message.c_str();
        }
};

class bad_memory_allocation_exception : public base_container_exception {
    public:
        explicit bad_memory_allocation_exception() = default;

        explicit bad_memory_allocation_exception(const char* message)
                : base_container_exception(message) {
        }

        explicit bad_memory_allocation_exception(std::string& message)
                : base_container_exception(message) {
        }

        virtual const char* what() const noexcept {
            return message.empty() ? "container::(bad memory allocation)!" : message.c_str();
        }
};

class out_of_range_exception : public base_container_exception {
    public:
        explicit out_of_range_exception() = default;

        explicit out_of_range_exception(const char* message)
                : base_container_exception(message) {
        }

        explicit out_of_range_exception(std::string& message)
                : base_container_exception(message) {
        }

        virtual const char* what() const noexcept {
            return message.empty() ? "container::(out of range)!" : message.c_str();
        }
};

#endif // CONTAINER_EXCEPTIONS_HPP
