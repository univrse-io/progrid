import * as admin from "firebase-admin";
import {setGlobalOptions} from "firebase-functions/v2";
import {onCall} from "firebase-functions/v2/https";

setGlobalOptions({region: "asia-southeast1"});

if (!admin.apps.length) admin.initializeApp();

/**
 * Grants an admin role for a user by email.
 */
export const grantAdminRole = onCall(async (request) => {
  const {email} = request.data;

  if (!email) throw new Error("Missing 'email' parameter.");

  try {
    const user = await admin.auth().getUserByEmail(email);

    await admin.auth().setCustomUserClaims(user.uid, {admin: true});

    await admin.firestore().collection("users").doc(user.uid)
      .update({admin: true});

    return {
      message:
        `Success! ${user.displayName ?? email} has been granted as an admin.`,
    };
  } catch (error) {
    console.error(`Failed to grant an admin role for ${email}.`, error);
    throw error;
  }
});
