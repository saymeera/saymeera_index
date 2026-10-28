const router = require('express').Router()
const {createTips, getTips, updateTips} = require('../../controllers/tips-controller/tipsController')
const adminAuthMiddleware = require('../../middlewares/adminAuth.middleware')
const userAuthMIddleware = require('../../middlewares/auth.middleware')

//Admin tips Apis
router.post("/addtips",adminAuthMiddleware, createTips)
router.get("/gettips",adminAuthMiddleware, getTips)
router.post("/updatetips/:id",adminAuthMiddleware, updateTips)



module.exports = router