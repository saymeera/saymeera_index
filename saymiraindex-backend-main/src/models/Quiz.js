const mongoose = require("mongoose")

const quizzes = new mongoose.Schema({
    quizNo: {type:Number, required:true},
    totalQuestions:{type:Number},
    questionsPerUser:{type:Number},
    expiryValue:{type:Number},
    expiryUnit:{type:String},
    // status:{type:String, enum:['DRAFT','PUBLISHED','COMPLETED'],default:'DRAFT'},
    status:{type:String,default:'DRAFT'},
    createdBy:{type:mongoose.Schema.Types.ObjectId, ref:'adminUser',required: true},
    quizPublishAt:{type:Date},
    expiryAt:{type:Date},
},{ timestamps: true })

module.exports = mongoose.model('Quiz',quizzes)