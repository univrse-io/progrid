import * as admin from "firebase-admin";
import {setGlobalOptions} from "firebase-functions/v2";
import {onCall} from "firebase-functions/v2/https";

setGlobalOptions({region: "asia-southeast1"});

if (!admin.apps.length) admin.initializeApp();

/**
 * Grants an admin role to a user retrieved by email.
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
      `Success! ${user.displayName} role as an admin has been granted.`,
    };
  } catch (error) {
    console.error(`Failed to grant admin role to ${email}.`, error);
    throw error;
  }
});

/**
 * Revokes an admin role from a user retrieved by email.
 */
export const revokeAdminRole = onCall(async (request) => {
  const {email} = request.data;

  if (!email) throw new Error("Missing 'email' parameter.");

  try {
    const user = await admin.auth().getUserByEmail(email);

    await admin.auth().setCustomUserClaims(user.uid, {admin: false});
    await admin.firestore().collection("users").doc(user.uid)
      .update({admin: false});

    return {
      message:
      `Success! ${user.displayName} role as an admin has been revoked.`,
    };
  } catch (error) {
    console.error(`Failed to revoke admin role from ${email}.`, error);
    throw error;
  }
});
