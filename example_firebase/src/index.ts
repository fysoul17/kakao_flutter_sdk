import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import * as kakao from "./kakao";

admin.initializeApp();

const kakaoAppId = functions.config().kakao.appid;

/**
 * customTokenFromKakao - Verifies kakao token then returns firebase token created
 *
 * @param  {any} data                                 Data that contains parameters provided by the client app
 * @param  {functions.https.CallableContext} context  Access token from Kakao Login API
 *
 * @return {Promise<string>}                          Firebase token
 */
export const customTokenFromKakao = functions.https.onCall(async (data, context) => {
  const token = data.token;
  if (!token) return { error: "There is no token provided." };

  return kakao
    .createFirebaseToken(+kakaoAppId, token)
    .then((firebaseToken) => {
      return { token: firebaseToken };
    })
    .catch((e) => {
      return { error: e.message ?? JSON.stringify(e) };
    });
});
