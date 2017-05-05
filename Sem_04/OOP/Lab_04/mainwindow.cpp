#include "mainwindow.hpp"
#include "ui_mainwindow.h"
#include <QDebug>
#include <QThread>

MainWindow::MainWindow(QWidget* parent) :
    QMainWindow(parent), ui(new Ui::MainWindow) {
    ui->setupUi(this);
    ui->currentFloorLCD->setStyleSheet("background : black;");
    ui->currentFloorLCD->setPalette(Qt::green);
    ui->currentFloorLCD->display(this->current_floor);
    ui->stateViewer->setText("undefined wait");

    this->setFixedSize(this->geometry().width(), this->geometry().height());

    this->set_up_call_button_signals();
    this->set_up_manage_button_signals();

    this->declare_states();
    this->set_up_transitions();
    this->set_up_machine();
}

MainWindow::~MainWindow() {
    delete ui;
}

void MainWindow::create_state(QState*& state, QString property, int duration, QState* parent) {
    state = new QState(parent);
    QTimer* timer = new QTimer(state);
    timer->setInterval(duration);
    timer->setSingleShot(true);
    QState* timing = new QState(state);
    connect(timing, SIGNAL(entered()), timer, SLOT(start()));
    QFinalState* done = new QFinalState(state);
    timing->addTransition(timer, SIGNAL(timeout()), done);
    state->setInitialState(timing);
    state->assignProperty(ui->stateViewer, "text", property);
}

void MainWindow::set_up_call_button_signals() {
    for (size_t i = 0; i < FLOOR_COUNT; ++i) {
        QString text = QString::number(i + 1);
        QPushButton* button = new QPushButton(text, this);
        this->call_buttons.push_back(button);
        ui->verticalLayout->addWidget(button);
        connect(this->call_buttons.at(i), SIGNAL(clicked()), this, SLOT(call_lift_button_clicked()));
    }
}

void MainWindow::set_up_manage_button_signals() {
    for (size_t i = 0; i < FLOOR_COUNT; ++i) {
        QString text = QString::number(i + 1);
        QPushButton* button = new QPushButton(text, this);
        this->manage_buttons.push_back(button);
        ui->verticalLayout_2->addWidget(button);
        connect(this->manage_buttons.at(i), SIGNAL(clicked()), this, SLOT(manage_lift_button_clicked()));
    }
}

void MainWindow::declare_states() {
    this->s1 = new QState();
    this->create_state(this->move, "move", 3000, this->s1);
    this->create_state(this->stop, "stop", 1000, this->s1);

    this->s2 = new QState();
    this->create_state(this->open, "open doors", 1000, this->s2);
    this->create_state(this->opening, "opening doors", 2000, this->s2);
    this->create_state(this->opened, "doors opened", 1000, this->s2);
    this->create_state(this->wait, "wait", 3000, this->s2);
    this->create_state(this->close, "close doors", 1000, this->s2);
    this->create_state(this->closing, "closing doors", 2000, this->s2);
    this->create_state(this->closed, "doors closed", 1000, this->s2);

    this->create_state(this->sudden_stop, "sudden stop", 1000);
    this->create_state(this->interim_state, "undefined wait", 1000);

    this->undefined_wait = new QFinalState();
}

void MainWindow::set_up_transitions() {
    this->s1->setInitialState(this->move);
    this->move->addTransition(this->move, SIGNAL(finished()), this->stop);
    this->stop->addTransition(this->stop, SIGNAL(finished()), this->s2);

    this->s2->setInitialState(this->open);
    this->open->addTransition(this->open, SIGNAL(finished()), this->opening);
    this->opening->addTransition(this->opening, SIGNAL(finished()), this->opened);
    this->opened->addTransition(this->opened, SIGNAL(finished()), this->wait);
    this->wait->addTransition(this->wait, SIGNAL(finished()), this->close);
    this->close->addTransition(this->close, SIGNAL(finished()), this->closing);
    this->closing->addTransition(this->closing, SIGNAL(finished()), this->closed);
    connect(this->closed, SIGNAL(finished()), this, SLOT(check_slot()));
    this->closed->addTransition(this, SIGNAL(queue_empty()), this->interim_state);
    this->closed->addTransition(this, SIGNAL(queue_filled()), this->s1);

    this->s1->addTransition(ui->stopButton, SIGNAL(clicked()), this->sudden_stop);
    this->s2->addTransition(ui->stopButton, SIGNAL(clicked()), this->sudden_stop);
    this->sudden_stop->addTransition(this->sudden_stop, SIGNAL(finished()), this->interim_state);

    this->interim_state->addTransition(this->interim_state, SIGNAL(finished()), this->undefined_wait);
}

void MainWindow::set_up_machine() {
    this->machine.addState(this->s1);
    this->machine.addState(this->s2);
    this->machine.addState(this->sudden_stop);
    this->machine.addState(this->interim_state);
    this->machine.addState(this->undefined_wait);
}

void MainWindow::call_lift_button_clicked() {
    QPushButton* button = static_cast<QPushButton*>(sender());
    const int button_number = button->text()[0].digitValue();

    if (!this->machine.isRunning()) {
        this->machine.setInitialState(this->current_floor == button_number ? this->s2 : this->s1);
        this->machine.start();
//        emit call_button_clicked(button_number);

    } else {
        this->queued_signals.push_back(SIGNAL(call_button_clicked(button_number)));
    }
}

void MainWindow::manage_lift_button_clicked() {
    QPushButton* button = static_cast<QPushButton*>(sender());
    const int button_number = button->text()[0].digitValue();

    if (!this->machine.isRunning()) {
        this->machine.setInitialState(this->current_floor == button_number ? this->s2 : this->s1);
        this->machine.start();
//        emit manage_button_clicked(button_number);

    } else {
        this->queued_signals.push_back(SIGNAL(manage_button_clicked(button_number)));
    }
}

void MainWindow::check_slot() {
    if (queued_signals.empty()) {
        emit queue_empty();

    } else {
        emit queue_filled();
    }
}
