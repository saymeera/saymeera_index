const axios = require("axios");

const verifyCaptcha = async (token) => {
  const secret = process.env.NODE_ENV === "production"? process.env.PROD_RECAPTCHA_SECRET:process.env.DEV_RECAPTCHA_SECRET;

  const res = await axios.post(
    "https://www.google.com/recaptcha/api/siteverify",
    null,
    {
      params: {
        secret,
        response: token,
      },
    }
  );

  return res.data; // { success, score, action }
};

module.exports = verifyCaptcha;
