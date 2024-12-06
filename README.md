Cornell Lost and Found App

Link to frontend: https://github.com/chelsea-she/Found-Frontend-App

Link to backend: https://github.com/Scott-Fukuda/Found-Backend-App

<img src="https://github.com/user-attachments/assets/86b57444-ec35-46b4-b14a-a2311d30969e" alt="Lost Request, pt1" width="150">
<img src="https://github.com/user-attachments/assets/99e32613-f8df-4a63-bbff-5a22c5e27a1e" alt="Lost Request, pt2" width="150">

<img src="https://github.com/user-attachments/assets/e7c3d754-5114-4f89-a93e-a5e06fcd73d9" alt="Found Post, pt1" width="150">
<img src="https://github.com/user-attachments/assets/ef8dcfbe-4497-4aa9-af1f-274c43d1463d" alt="Found Post, pt2" width="150">
<img src="https://github.com/user-attachments/assets/357149e4-c52c-424d-8f6a-8350eae39489" alt="Found Post, pt3" width="150">

<img src="https://github.com/user-attachments/assets/46fb3dd7-9346-4eb3-902e-deea727c2da4" alt="Found Post Submission, pt4" width="150">

**Description**
Found is a forum where users can post lost items and other users can create requests to retrieve said items. When a user finds a lost item, they can create a "found post".
Users can navigate to the "found post" tab, where they will be prompted with several questions about the item they've found. This post is then added to a database of posts.
When another user realizes they've lost an item, they can submit a "lost request" containing information about their lost item. This "lost request" is matched up against the
different "found posts" and the "found posts" that match certain specifications are displayed to the user. This acts as a security measure against malicious users attempting
to claim items that do not belong to them. Once a user identifies their lost item, they can claim this item and receive information about where it is located. As additional
security measures, users can only make 3 "lost requests" per week, and each user can only create an account with a Cornell email through Google login.

**How Frontend Requirements Are Met**
We have 9 views that we navigate through. 
1) AuthView is the sign in page. Users can sign in with either an email or google account through Firebase.
2) SignupView is for first time users, to finish creating their account including a password, displayName, phone and a bio TextField.
3) GoogleSignupView is for first time Google users that is the same as SignupView but doesn’t have a password TextField.
4) ProfileView is the tab that displays the user’s account information and allows them to logout.
5) FoundView is the tab to post a found lost item.
6) The FoundPushSuccessPage view will display the successful post of the found item after a user submitted.
7) LostView is a tab to request a lost item.
8) The ViewLostQueries view will display the related posts of found items that a user requested as lost.
9) ReceivedView is a tab to confirm receiving a found item.

Our ViewLostQueries view will be scrollable so the user can scroll through multiple related posts of their lost item.

We deployed our backend API on Google Cloud and integrated networking to access user information, lost requests, received requests, and found posts.

