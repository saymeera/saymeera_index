const router = require('express').Router()
const {createQuiz,updateQuiz, getQuizzes, addQuistion, getQuizQuistions, publishQuiz, updateQuestion, deleteQuestion, getliveQuiz, QuizAction} = require('../../controllers/quiz-controller/quizController')
const adminAuthMiddleware = require('../../middlewares/adminAuth.middleware')
const userAuthMIddleware = require('../../middlewares/auth.middleware')

//Admin quiz Apis
router.post("/addquiz",adminAuthMiddleware, createQuiz)
router.get("/getquizlist",adminAuthMiddleware, getQuizzes)
router.post("/addquistion",adminAuthMiddleware, addQuistion)
router.post("/getDefaultQuizQuestion",adminAuthMiddleware, getQuizQuistions)
router.post("/quizpublish",adminAuthMiddleware, publishQuiz)
router.post("/updatequizbucket/:id",adminAuthMiddleware, updateQuiz)
router.delete("/deletequizbucket/:id",adminAuthMiddleware, deleteQuiz)
router.post("/updatequestion/:id",adminAuthMiddleware, updateQuestion)
router.delete("/deletequestion/:id",adminAuthMiddleware, deleteQuestion)

//user Quiz Apis

router.get("/getlivequiz",userAuthMIddleware, getliveQuiz)
router.get("/actionOnquiz",userAuthMIddleware, QuizAction)



module.exports = router