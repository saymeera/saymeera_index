const Quiz = require('../../models/Quiz')
const QuizQuestion = require('../../models/quiz_questions')
const mongoose = require('mongoose');

//Admin Quiz Controller 

createQuiz = async (req, res) => {
    try {
        const { quizNo, totalQuestions, questionsPerUser, expiryValue, expiryUnit, status } = req.body;
        if (!quizNo || !totalQuestions || !questionsPerUser) {
            return res.status(400).json({
                success: false,
                message: 'Required fields missing'
            });
        }
        const userId = req.user.id;
        const quiz = new Quiz({
            quizNo,
            totalQuestions,
            questionsPerUser,
            expiryValue,
            expiryUnit,
            status,
            createdBy: userId
        })
        const savedQuiz = await quiz.save()
        res.status(201).json({
            success: true,
            message: 'Quiz created successfully',
            data: savedQuiz
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server error',
            error: error.message
        });
    }
}

getQuizzes = async (req, res) => {
    try {
        let quizzes = await Quiz.find({}).select('_id quizNo totalQuestions questionsPerUser expiryValue expiryUnit expiryAt status').sort({ createdAt: -1 });
        res.status(200).json({ quizlist: quizzes })
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server error',
            error: error.message
        });
    }
}

addQuistion = async (req, res) => {
    try {
        const { quizId, questionText, optionType, options, correctOption } = req.body
        const quiz = await Quiz.findById(quizId)
        if (quiz.status !== 'DRAFT') {
            return res.status(400).json({
                success: false,
                message: 'You cannot add questions to this quiz'
            });
        }
        const questionCount = await QuizQuestion.countDocuments({ quizId });
        if (questionCount >= quiz.totalQuestions) {
            // quiz ko COMPLETED kar do
            quiz.status = 'COMPLETED';
            await quiz.save();

            return res.status(400).json({
                success: false,
                message: 'Question limit reached. Quiz marked as COMPLETED'
            });
        }
        const questionNo = questionCount + 1;
        const newQuistion = new QuizQuestion({
            quizId,
            questionNo,
            questionText,
            optionType,
            options,
        })
        await newQuistion.save()
        if (questionNo === quiz.totalQuestions) {
            quiz.status = 'COMPLETED';
            await quiz.save();
        }
        res.status(201).json({
            success: true,
            message: 'Question added successfully',
            questionNo,
            quizStatus: quiz.status
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server error',
            error: error.message
        });
    }
}

getQuizQuistions = async (req, res) => {
    try {
        let latestQuizId = req.body.quizId
        let quistions = await QuizQuestion.find({ quizId: latestQuizId }).populate('quizId', 'quizNo').select('questionNo questionText options optionType')
        res.status(200).json({
            success: true,
            message: 'fetched Quistion list',
            data: quistions
        })
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server error',
            error: error.message
        });
    }
}

publishQuiz = async (req, res) => {
    try {
        const { quizId } = req.body;
        const quiz = await Quiz.findById(quizId);
        if (!quiz) {
            return res.status(404).json({
                success: false,
                message: 'Quiz not found'
            });
        }
        const now = new Date();
        let expiryAt = new Date(now);
        if (quiz.expiryUnit === 'hours') {
            expiryAt.setHours(expiryAt.getHours() + quiz.expiryValue);
        } else if (quiz.expiryUnit === 'days') {
            expiryAt.setDate(expiryAt.getDate() + quiz.expiryValue);
        }
        quiz.status = 'PUBLISHED';
        quiz.quizPublishAt = now;
        quiz.expiryAt = expiryAt;
        await quiz.save();

        res.status(200).json({
            success: true,
            message: 'Quiz published successfully',
            quiz
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server error',
            error: error.message
        });
    }
};


updateQuiz = async (req, res) => {
    try {
        const quizId = req.params.id;
        const payload = req.body;
        const updatedQuiz = await Quiz.findByIdAndUpdate(
            quizId,
            payload,
            { new: true }
        );
        res.status(200).json({
            success: true,
            message: 'Quiz updated successfully',
            quiz: updatedQuiz
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server error',
            error: error.message
        });
    }
}

updateQuestion = async (req, res) => {
    try {
        const QueId = req.params.id
        const payload = req.body
        const updateQue = await QuizQuestion.findByIdAndUpdate(QueId, payload)
        res.status(200).json({
            success: true,
            message: 'Quetion updated successfully',
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server error',
            error: error.message
        });
    }
}

deleteQuiz = async (req, res) => {
    // const session = await mongoose.startSession();
    try {
        const quizId = req.params.id;
        // session.startTransaction();
        const quiz = await Quiz.findByIdAndDelete(quizId);
        if (!quiz) {
            await session.abortTransaction();
            session.endSession();
            return res.status(404).json({
                success: false,
                message: 'Quiz not found'
            });
        }
        await QuizQuestion.deleteMany({ quizId });

        // await session.commitTransaction();
        // session.endSession();
        res.status(200).json({
            success: true,
            message: 'Quiz and all related questions deleted successfully',
        });
    } catch (error) {
        // await session.abortTransaction();
        // session.endSession();
        res.status(500).json({
            success: false,
            message: 'Server error',
            error: error.message
        });
    }
}

deleteQuestion = async (req, res) => {
    try {
        const queId = req.params.id;
        const que = await QuizQuestion.findByIdAndDelete(queId);
        res.status(200).json({
            success: true,
            message: 'Questions deleted successfully',
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: 'Server error',
            error: error.message
        });
    }
}

//user Quiz Controller

getliveQuiz = async (req, res) => {
    try {
        const userId = req.user._id;
        const now = new Date();

        // 1. LIVE & NOT EXPIRED quizzes
        const liveQuizzes = await Quiz.find({
            status: "PUBLISHED",
            expiryAt: { $gt: now }
        }).select("_id quizNo expiryAt questionsPerUser");

        // 2. User attempted quizzes
        const sessions = await QuizUserSession.find({
            ourUserId: userId,
            status: { $in: ["UNCOVERED", "COMPLETED", "EXITED"] }
        }).select("quizId");

        const attemptedQuizIds = sessions.map(s => s.quizId.toString());

        // 3. Filter
        const result = liveQuizzes.filter(
            quiz => !attemptedQuizIds.includes(quiz._id.toString())
        );

        res.status(200).json({
            success: true,
            quizzes: result
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            message: "Server error",
            error: error.message
        });
    }
}

QuizAction = async (req, res) => {
  try {
    const { quizId, platform } = req.body;
    const userId = req.user._id;
    const now = new Date();

    // 1. Validate quiz
    const quiz = await Quiz.findOne({
      _id: quizId,
      status: "PUBLISHED",
      expiryAt: { $gt: now }
    });

    if (!quiz) {
      return res.status(400).json({
        success: false,
        message: "Quiz not available or expired"
      });
    }

    // 2. Check existing session
    const existingSession = await QuizUserSession.findOne({
      quizId,
      ourUserId: userId,
      status: { $in: ["UNCOVERED", "EXITED", "COMPLETED"] }
    });

    if (existingSession) {
      return res.status(403).json({
        success: false,
        message: "You have already attempted this quiz"
      });
    }

    // 3. Random unique questions
    const questions = await QuizQuestion.aggregate([
      { $match: { quizId: quiz._id } },
      { $sample: { size: quiz.questionsPerUser } }
    ]);

    if (questions.length < quiz.questionsPerUser) {
      return res.status(400).json({
        success: false,
        message: "Not enough questions available"
      });
    }

    // 4. Create session
    const session = new QuizUserSession({
      quizId,
      ourUserId: userId,
      platform,
      assignedQuestions: questions.map(q => q._id),
      quizSendToUser: true,
      sendTiming: now,
      status: "UNCOVERED",
      uncoverTime: Date.now()
    });

    await session.save();

    // 5. Send questions
    res.status(200).json({
      success: true,
      message: "Quiz uncovered successfully",
      sessionId: session._id,
      expiryAt: quiz.expiryAt,
      questions
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Server error",
      error: error.message
    });
  }
};



module.exports = {
    createQuiz,
    getQuizzes,
    addQuistion,
    getQuizQuistions,
    publishQuiz,
    updateQuiz,
    updateQuestion,
    deleteQuestion,
    getliveQuiz,
    QuizAction
}