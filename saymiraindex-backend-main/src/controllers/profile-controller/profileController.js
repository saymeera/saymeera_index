const User = require('../../models/User')
const { logActivity } = require('../activity-logs/activityLogger')
const { ACTIVITY } = require('../../utils/constant')

exports.getUserDatabyId = async (req, res) => {
    try {
        const userId = req.params.id;
        const user = await User.findOne({ _id: userId }).select("name email mobile gender dOB isAdmin isIndividual userId registeredAt discountCode referralUserId brokerUserId");
        if (!user) {
            return res.status(404).json({ message: "User not found", status: false })
        }
        logActivity({
            req,
            userId: userId,
            action: ACTIVITY.PROFILE_VIEW,
            description: "User view profile",
        })
        res.json(user);
    } catch (error) {
        res.status(500).json({ message: "Server error" });
    }
}

exports.updateUserProfile = async (req, res) => {
    try {
        const userId = req.params.id;
        if (req.userId !== userId) {
            return res.status(403).json({ message: "You can only update your own profile", status: false });
        }

        const allowedUpdates = ["name", "gender", "dOB"];
        const updates = {};
        allowedUpdates.forEach(field => {
            if (req.body[field] !== undefined) {
                updates[field] = req.body[field];
            }
        });
        if (Object.keys(updates).length === 0) {
            return res.status(400).json({ message: "No valid fields to update" });
        }
        const updatedUser = await User.findByIdAndUpdate(
            userId,
            { $set: updates },
            { new: true }
        ).select("name gender dOB email mobile isIndividual isAdmin userId registeredAt");

        logActivity({
            req,
            userId: req.user.id,
            action: ACTIVITY.PROFILE_UPDATE,
            description: "User update profile",
            metadata: {
                updatedFields: Object.keys(req.body)
            }
        });

        res.json(updatedUser);
    } catch (error) {
        res.status(500).json({ message: "Server error" });
    }
}