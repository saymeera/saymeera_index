const mongoose = require("mongoose")

const quizQuestionSchema = new mongoose.Schema({
    quizId: { type: mongoose.Schema.Types.ObjectId, ref: "Quiz", required: true,index: true },
    questionNo: {type: Number, required: true },
    questionText: { type: String, required: true },
    optionType:{type:String,required:true},
    // options: [{ key: { type: String, required: true }, text: { type: String, required: true } }],
    options: {type: [String],required: true},
    correctOption: { type: String, default: null},    // admin will update later
    questionEntryTime:{type: Date,default: Date.now},
    answerUpdateTime:{type: Date,default: null},
    isActive: {type: Boolean,default: true}
})

module.exports = mongoose.model("QuizQuestion", quizQuestionSchema);
