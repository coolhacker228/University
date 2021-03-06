#include "controller.hpp"
#include <QDebug>
#include <QApplication>

Controller::Controller(QObject* parent) : QObject(parent) {
    this->setUpConnections();
}

void Controller::setUpConnections() {
    connect(this, SIGNAL(move()), &this->elevator, SLOT(enteredMoving()));
    connect(&this->elevator, SIGNAL(finishedMoving()), this, SLOT(finishedMoving()));
    connect(this, SIGNAL(changeFloor()), &this->elevator, SLOT(enteredFloorChanged()));
    connect(&this->elevator, SIGNAL(finishedFloorChanged()), this, SLOT(finishedFloorChanged()));
    connect(this, SIGNAL(stop()), &this->elevator, SLOT(enteredStopped()));
    connect(&this->elevator, SIGNAL(finishedStopped()), this, SLOT(finishedStopped()));
    connect(this, SIGNAL(open()), &this->doors, SLOT(enteredOpening()));
    connect(&this->doors, SIGNAL(finishedOpened()), &this->elevator, SLOT(enteredWaiting()));
    connect(&this->elevator, SIGNAL(finishedWaiting()), &this->doors, SLOT(enteredClosing()));
    connect(&this->doors, SIGNAL(finishedClosed()), this, SLOT(finishedClosed()));
    connect(this, SIGNAL(shutDown()), &this->elevator, SLOT(shuttedDown()));
    connect(&this->elevator, SIGNAL(stateChanged(Elevator::State)), this, SLOT(elevatorStateChangedAcceptor(Elevator::State)));
    connect(&this->doors, SIGNAL(stateChanged(Doors::State)), this, SLOT(doorsStateChangedAcceptor(Doors::State)));
}

void Controller::callButtonPressed(int value) {
    this->blockSignals(false);

    if (this->elevator.getState() == Elevator::State::UNDEFINED_WAITING
        && this->doors.getState() == Doors::State::CLOSED) {

        if (value == this->currentFloor) {
            emit open();

        } else {
            this->destinationFloor = value;
            emit move();
        }

    } else {
        this->callSignals.enqueue(value);
    }
}

void Controller::controlButtonPressed(int value) {
    this->blockSignals(false);

    if (this->elevator.getState() == Elevator::State::UNDEFINED_WAITING
        && this->doors.getState() == Doors::State::CLOSED) {

        if (value == this->currentFloor) {
            emit open();

        } else {
            this->destinationFloor = value;
            emit move();
        }

    } else {
        this->controlSignals.enqueue(value);
    }
}

void Controller::finishedMoving() {
    if (this->elevator.getState() == Elevator::State::MOVING
        && this->doors.getState() == Doors::State::CLOSED) {
        emit changeFloor();
    }
}

void Controller::finishedFloorChanged() {
    if (this->elevator.getState() == Elevator::State::FLOOR_CHANGED
        && this->doors.getState() == Doors::State::CLOSED) {
        if (this->currentFloor == this->destinationFloor) {
            emit stop();

        } else {
            emit move();
        }
    }
}

void Controller::finishedStopped() {
    if (this->elevator.getState() == Elevator::State::STOPPED
        && this->doors.getState() == Doors::State::CLOSED) {
        emit open();
    }
}

void Controller::finishedClosed() {
    if (this->elevator.getState() == Elevator::State::WAITING
            && this->doors.getState() == Doors::State::CLOSED) {
        if (callSignals.isEmpty() && controlSignals.isEmpty()) {
            emit shutDown();

        } else {

            if (this->callSignals.isEmpty() && !this->controlSignals.isEmpty()) {
                this->destinationFloor = this->controlSignals.dequeue();

            } else if (!this->callSignals.isEmpty() && this->controlSignals.isEmpty()) {
                this->destinationFloor = this->callSignals.dequeue();

            } else {

                if (this->callSignals.first() < this->controlSignals.first()) {
                    this->destinationFloor = this->callSignals.dequeue();

                } else {
                    this->destinationFloor = this->controlSignals.dequeue();
                }
            }

            if (this->currentFloor == this->destinationFloor) {
                emit open();

            } else {
                emit move();
            }
        }
    }
}

void Controller::elevatorStateChangedAcceptor(Elevator::State state) {
    if (state == Elevator::State::FLOOR_CHANGED) {
        this->currentFloor > this->destinationFloor ? --this->currentFloor : ++this->currentFloor;
        emit setFloor(this->currentFloor);
    }

    emit elevatorStateChanged(state, this->currentFloor < this->destinationFloor ? true : false);
}

void Controller::doorsStateChangedAcceptor(Doors::State state) {
    emit doorsStateChanged(state);
}
