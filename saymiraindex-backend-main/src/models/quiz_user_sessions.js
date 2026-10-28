const mongoose = require("mongoose")
const quizUserSessionSchema = new mongoose.Schema({
    quizId: { type: mongoose.Schema.Types.ObjectId, ref: "Quiz", required: true, index: true},
    ourUserId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true,index: true },
    // brokerUserId: { type: mongoose.Schema.Types.ObjectId, ref: "Broker" },
    platform: { type: String, enum: ["WEB", "MOBILE"], required: true },
    assignedQuestions: [{ type: mongoose.Schema.Types.ObjectId, ref: "QuizQuestion", required: true }],
    quizSendToUser: { type: Boolean, default: false },
    sendTiming: { type: Date },
    status: { type: String, enum: ["SENT", "UNCOVERED", "EXITED", "COMPLETED"], default: "SENT" },
    uncoverTime: { type: Number },
    exitTime: { type: Number },
}, { timestamps: { createdAt: "createdTime", updatedAt: "updatedTime" } })

module.exports = mongoose.model("QuizUserSession", quizUserSessionSchema);
