![Logo](drive-download-20250415T001154Z-001/Green%20Minimalist%20Online%20Shop%20Logo%20Icon%20(1).png)

Malaysian Sign Language (MLS) is the official sign language of Malaysia as recognised in the Person With Disability Act 2008. However, due to the lack of attention and awareness, communication barriers persist between the Deaf and hearing communities. This study aims to explore the research gap in the sign language recognition domain and create a gamified sign language education mobile application with computer vision integration to close the communication gap between the deaf and the hearing. The proposed solution targets Sustainable Development Goal 4 and focuses on providing quality educational content for all regardless of age, gender, or ability. To ensure the system's effectiveness, the researcher conducted in-depth interviews and collected feedback and opinion from four participants, detailed analysis was done to gain valuable insights and outline the design idea of the proposed system. The Kanban methodology is chosen to manage the system development process during the development phase. The detail of the system design and implementation was discussed thoroughly, including the development of sign language recognition model with different model architecture of Long Short-Term Memory model. The developed system is tested and evaluated carefully to identify its contribution to the Deaf community and potential future enhancement.

## Register/Sign up Screen

<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-17-30-31-93_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

The Sign Up screen facilitates users with no existing account registering their account to access the content in the application. The information collected includes their name, email address, password, and confirmation password. Their username is used for display purposes and can be changed later in the application. Email and password will be used as credentials for user to access their account even on other devices after registration. There are snackbar that notify user on the issues of their input, including name and passwords that are too short, invalid email, as well as unmatched password and confirmation password. If the user already has an account, they can click on the hyperlink under the Sign Up button to navigate to the Login screen. 

## Login Screen
  
<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-17-30-28-87_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

The Login screen allows user with existing accounts to log in using their email and password. They have to use valid credentials to log in, or else there will be a snackbar telling them the credentials are incorrect. If users do not have an existing account, they can click on the hyperlink under the Login button to navigate to the signup page.
 
## Home screen

<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-17-34-38-65_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/><img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-17-34-49-89_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

After users successfully register or log in, they will be navigated to the home screen. There is a bottom navigation bar that allows users to access other modules in the application, namely the class and exam menu, the translation screen, and the community hub. On the home screen, the virtual pet is available for interaction using the feed button. There is a progress bar that shows the level and experience of user, it indicates the closeness of users with their pets, which can be increased by feeding the pet. There is also a streak widget where users can claim rewards daily. The reward can only be claimed once a day, and claiming on consecutive days will yield a greater reward. Then, there is a hamburger menu icon at the upper left corner, clicking on it will open the drawer.
 
## Drawer screen

<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-15-09-04-27-35_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

In the Drawer, the profile picture and username of the user are shown. Users can click on the edit button next to their username to edit their username. Other than that, clicking on the Signout button will open an alert dialog to confirm if the user wants to sign out. Clicking on cancel will close the dialog, while clicking on yes will sign the user out and navigate them back to the login screen 
 
## Food Menu Screen

<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-18-03-47-22_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

Clicking on the feed button in the home screen will open a food menu, where users can spend coins to purchase food for their pet. If the user has enough coins for the food chosen, the experience will be increased accordingly, and a snackbar is shown to tell the user the purchase is successful. Otherwise, if the user does not have enough coins for the chosen food, there will be a snackbar showing “Not enough coins!” and no experience increase.
 
## Class, Evaluation, and Fingerspelling Menu screen
   
<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-15-09-04-16-75_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/><img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-16-22-07-38-63_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/><img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-16-22-07-41-65_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

Clicking on the second item in the bottom navigation bar will bring the users to the class, evaluation, and fingerspelling menu. Users can navigate between the menus by using the tab bar at the top. Clicking on the topic of the day widget of any other topic will bring users to the class or exam of the topic chosen. If the topic has already been completed, there will be a green tick in the upper right corner of the topic widget. Clicking on the Fingerspelling tab will bring user to the list view for alphabets. User can click on the alphabet to go the sign tutorial display screen fo the alphabet. There is a floating button at the bottom right corner of the menu, which will take users to their learning path screen.
 
## Learning Path screen
   
<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-17-39-16-22_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

Users can track their progress in the learning path screen, where user can see how many class or evaluation they had already completed. They can also check the progress of each topic individually and directly access the class and evaluation module from this screen. Users can revisit topic completed or go complete uncompleted topics. Other than that, users can choose to visit each word in the topic individually. By clicking on the view button, users will be navigated to the sign tutorial display screen.
 
## Class Sign Tutorial Display screen

<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-17-35-14-16_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

Once users click on the class topic, they will be directed to the Class Sign Tutorial Display screen, each class will have 5 of this, each display a new sign. Users can play and pause the video based on their needs. Clicking on the ‘Got it!’ button will bring them to a quiz related to the signs learned in that topic. If the user decide to quit the class, there will be an alert dialog to confirm if they want to discard their progress and leave.
 
## Class Sign MCQ quiz screen
   
<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-17-35-52-76_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/><img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-17-36-17-82_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

The MCQ quiz screen is used to evaluate users’ ability to recognise signs based on the word. When user select an answer from the four options, feedback will be given according to the accuracy of the answer. If the answer is wrong, user need to re-select an answer, else if the answer is correct, user can proceed to the next quiz or sign tutorial.
 
## Class Name the Sign quiz screen

<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-17-36-45-46_66a6d75df551272eff152acef7963861(1).jpg" alt="image" width="200"/><img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-17-36-50-91_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

Users are given quiz that evaluate their ability to recognise and name the sign based on the tutorial video. Users need to input the name of the sign in the text field and click on the submit button. If the answer is wrong, users need to try again, else they can proceed to the next quiz or sign tutorial video.
 
## Completion/Congratulation screen
 
<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-17-39-03-53_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

Once the user completes all the sign tutorials and quizzes in a class or completes all the questions in a topic evaluation, they will be navigated to the completion screen. By clicking on the claim reward button, the user receives 100 coins for completing a class or 150 coins for completing an evaluation. Then, the user will be navigated to the class menu or evaluation menu.
 
## Evaluation screen

<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-23-34-28-06_965bbf4d18d205f782c6b8409c5773a4.jpg" alt="image" width="200"/>

Once the user clicks on an evaluation topic, they will be directed to a screen with sign language recognition. The sign to be detected will be displayed at the top, and the user can click on start recording to record their sign performance. Clicking on the start recording button will start a 3 – 3-second timer so that users have enough time to get ready to perform the sign.

<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-23-35-16-02_965bbf4d18d205f782c6b8409c5773a4.jpg" alt="image" width="200"/>

After the countdown of 2, 1, GO!, the recording is started, and the user can perform the sign within 30 frames. Then, the 30 frames will be sent for processing and detection.
 
## Evaluation feedback screen

<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-23-36-16-73_965bbf4d18d205f782c6b8409c5773a4.jpg" alt="image" width="200"/>

After the response is received, the feedback screen will show the user if the sign performed is correct or incorrect. The tutorial video is also shown so that the user can revise the sign and enhance their signing skill. If the sign performed is incorrect, the user can try again to perform the same sign, else if the sign is performed correctly, the user can proceed to perform the next sign.
 
## Translation screen

<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-17-43-29-43_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>
   
In the translation screen, users can translate different language to Malaysian Sign Language. By inputting the word to translate and click on the Translate button, the word will be translated to Malaysian Sign Language. Users need to wait for the response for the previous request before they can send another translate request. If they decide to send another request before receiving a response, a snackbar will be shown to tell the user they need to wait for a second. Once the response is received, the sign language video will be displayed alongside the English and Malay translation of the Sign. The translator is able to identify typo in the input and find the most suitable translation of the input in various languages.
 
## Community Hub screen
   
<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-18-02-10-77_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

There are three different views in the community hub, which includes the posts from users nearby, all posts, and the posts posted by the user. In the Nearby tab, users can view posts that are posted with location information by users nearby, users need to enable location service and grant location permission to the application. In the All tab, users can view posts from all users regardless of their location. In the My Post tab, users can view posts posted by themselves and manage their post. Users can interact with posts by using the like button, comment button and share button. Clicking on a like button for a post can like or unlike the post, liked posts also has a red like button instead of a white like button. Clicking on the comment button will navigate users to the comment screen of that particular post. Then, clicking on the share button will create an image of the post so users can share with other people through social medias including WhatsApp, Facebook, Google Drive, and many more. There is also an “+ Post” floating button in the bottom right of the screen which will navigate users to the post screen. 

## Comment screen

<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-15-15-22-58-97_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

Users can view all the comments under a post and create comments for the post in its comment screen. If the user attempts to create an empty comment by clicking on the send button without putting in any input in the text field, a snackbar will pop up to notify the user that they cannot create an empty comment. If the comment is created successfully, the user will be able to see the comment published in the comment screen, and there will be a snackbar to notify the user upon the success.
 
## Post screen

<img src="drive-download-20250415T001154Z-001/Screenshot_2025-04-14-18-03-16-69_66a6d75df551272eff152acef7963861.jpg" alt="image" width="200"/>

Users can create posts in the Post screen. Users can decide whether to share their posts to users nearby which would require the location permission and service or to just post in the general channel. If the user decides to share their post with users nearby without enabling the location service or without granting location permission, a snackbar will pop up to notify users to enable the service. Other than that, users cannot post without a title and content, a snackbar will be shown to notify users that they need to fill in both fields before they can create the post. Once the post is created successfully, the user will be navigated back to the community hub, and there will be a snackbar to notify the user that their post is created successfully. There will also be an alert dialog if the user try to leave this screen to confirm they want to leave before posting their draft, avoiding accidental draft discarding.
