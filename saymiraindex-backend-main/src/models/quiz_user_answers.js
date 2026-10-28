const mongoose = require("mongoose")
const quizUserAnswerSchema = new mongoose.Schema({
    quizId: { type: mongoose.Schema.Types.ObjectId, ref: "Quiz", required: true,index: true },
    ourUserId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true,index: true },
    questionId: { type: mongoose.Schema.Types.ObjectId, ref: "QuizQuestion", required: true },
    chosenOption: { type: String, required: true },
    answeredAt: { type: Number, required: true }
}, { timestamps: true })
module.exports = mongoose.model("QuizUserAnswer", quizUserAnswerSchema);