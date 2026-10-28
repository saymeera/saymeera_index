const Tips = require('../../models/Tips')
const mongoose = require('mongoose');

createTips = async (req, res) => {
    try {
        console.log(req.body, 'sdfghjkl')
        const {
            tipsScript,
            buySell,
            stopLoss,
            expiryUnit,
            target,
            // tipsPublishAt,
            // expiryAt
        } = req.body
        const tipsMsg = `${tipsScript} | ${buySell} | SL: ${stopLoss} | ${expiryUnit} | Target: ${target}`
        console.log(req.user.id, "req.user._id ")
        const newTips = new Tips({
            tipsScript,
            buySell,
            stopLoss,
            expiryUnit,
            target,
            tipsMsg,
            // tipsPublishAt,
            // expiryAt,
            createdBy: req.user.id   // JWT middleware se aayega
        })

        const savedTips = await newTips.save()

        res.status(201).json({
            success: true,
            message: "Tips created successfully",
            data: savedTips
        })

    } catch (error) {
        console.log(error)
        res.status(500).json({
            status: false,
            message: "Server error"
        })
    }
}

getTips = async (req, res) => {
    try {
        console.log("sjdgfkjhsdgfkjhgkjh")
        const allTips = await Tips.find({ status: "Active" }).populate({ path: 'createdBy', select: 'fullName email' })
        // console.log(allTips, "allTips")
        res.status(201).json({
            success: true,
            message: "Tips created successfully",
            data: allTips
        })

    } catch (error) {
        res.status(500).json({
            status: false,
            message: "Server error"
        })
    }
}

updateTips = async (req, res) => {
    try {
        const tipId = req.params.id;

        const {
            tipsScript,
            buySell,
            stopLoss,
            expiryUnit,
            target
        } = req.body;

        // tipsMsg dubara generate karo
        const tipsMsg = `${tipsScript} | ${buySell} | SL: ${stopLoss} | ${expiryUnit} | Target: ${target}`;

        const tipUpdate = await Tips.findByIdAndUpdate(
            tipId,
            {
                tipsScript,
                buySell,
                stopLoss,
                expiryUnit,
                target,
                tipsMsg
            },
            { new: true } // updated document return karega
        );

        if (!tipUpdate) {
            return res.status(404).json({
                success: false,
                message: "Tip not found"
            });
        }

        res.status(200).json({
            success: true,
            message: "Tips updated successfully",
            data: tipUpdate
        });

    } catch (error) {
        console.log(error);
        res.status(500).json({
            success: false,
            message: "Server error"
        });
    }
};


module.exports = {
    createTips,
    getTips,
    updateTips
}

