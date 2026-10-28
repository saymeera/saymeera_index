const router = require('express').Router()
const { getUserDatabyId, updateUserProfile } = require("../../controllers/profile-controller/profileController")
const verifyAccessToken = require("../../middlewares/auth.middleware")

router.post('/getUserDatabyId/:id', verifyAccessToken, getUserDatabyId)
router.put('/updateUserProfile/:id', verifyAccessToken, updateUserProfile)

module.exports = router