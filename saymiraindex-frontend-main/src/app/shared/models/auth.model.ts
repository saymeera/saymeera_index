export interface SendMsgResponse{
    message:string;
}

export interface LoginResponse{
    accessToken:string
    refreshToken:string
    userId:string
}

export interface RefreshTokenRequest {
  refreshToken: string | null;
}
export interface RefreshTokenResponse {
  accessToken:string;
}

export interface MobileOtpPayload{
    mobile:string | null | undefined;
}

export interface EmailOtpPayload{
    email:string | null | undefined;
}

export interface verifyMobOtp{
    mobile:string | null | undefined;
    otp:string | null | undefined;
}

export interface verifyMailOtp{
    email:string;
    otp:string;
}