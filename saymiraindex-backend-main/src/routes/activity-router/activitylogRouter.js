const router = require('express').Router()
const { getloginActivity, getActivityLog } = require('../../controllers/activity-logs/activityLogger')
const verifyAccessToken = require("../../middlewares/auth.middleware")

router.get('/getloginActivity/:id', verifyAccessToken, getloginActivity)
router.get('/getUserActivitylog/:id', verifyAccessToken, getActivityLog)

module.exports = router