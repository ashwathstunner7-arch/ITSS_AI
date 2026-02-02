-- Database: AI_USER
-- Generated on: 2026-01-31 19:47:33.608752

SET FOREIGN_KEY_CHECKS = 0;


-- Structure for table: RULES
CREATE TABLE `RULES` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text,
  `rule_content` longtext NOT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` enum('active','inactive','draft') DEFAULT 'active',
  `version` varchar(20) DEFAULT '1.0',
  `category` varchar(100) DEFAULT NULL,
  `priority` enum('low','medium','high','critical') DEFAULT 'medium',
  PRIMARY KEY (`id`),
  KEY `idx_title` (`title`),
  KEY `idx_status` (`status`),
  KEY `idx_category` (`category`),
  KEY `idx_priority` (`priority`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table: RULES
INSERT INTO `RULES` (`id`, `title`, `description`, `rule_content`, `created_by`, `created_at`, `updated_at`, `status`, `version`, `category`, `priority`) VALUES (1, 'KONY Application Development Standards', 'Official KONY platform development standards and best practices', 'KONY APPLICATION DEVELOPMENT STANDARDS

1. ARCHITECTURE STANDARDS:
• Use MVC architecture pattern
• Implement service-oriented architecture
• Follow KONY Visualizer framework guidelines
• Use KONY Fabric for backend integration

2. UI/UX STANDARDS:
• Follow KONY component library
• Responsive design for all screen sizes
• Use KONY theme framework
• Implement accessibility (WCAG 2.1 compliance)

3. CODE QUALITY STANDARDS:
• JavaScript ES6+ for client-side
• Java 8+ for server-side components
• Use KONY APIs for native device features
• Follow naming conventions:
  - Variables: camelCase
  - Classes: PascalCase
  - Constants: UPPER_SNAKE_CASE
  - Functions: verbNoun format (e.g., getUserData)

4. SECURITY STANDARDS:
• Implement OAuth 2.0 for authentication
• Use HTTPS for all API calls
• Encrypt sensitive data at rest
• Validate all user inputs
• Implement proper session management

5. PERFORMANCE STANDARDS:
• Limit HTTP calls - batch when possible
• Implement lazy loading
• Optimize images and assets
• Use caching strategies
• Target 3-second page load time

6. TESTING STANDARDS:
• Unit testing with Kony Jasmine framework
• Integration testing for Fabric services
• UI testing with Kony Visualizer
• Performance testing for all modules

7. DEPLOYMENT STANDARDS:
• Use Kony MobileFabric for deployment
• Implement CI/CD pipeline
• Version control using Git
• Follow semantic versioning

8. DOCUMENTATION STANDARDS:
• Document all public APIs
• Maintain README files
• Code comments for complex logic
• Change log maintenance

COMPLIANCE REQUIREMENTS:
• GDPR compliance for European users
• HIPAA compliance for healthcare apps
• PCI DSS for payment applications
• Local data privacy regulations

REVIEW PROCESS:
• Peer review mandatory for all code
• Security review for sensitive features
• Performance review for critical modules
• UX review for all user interfaces', NULL, '2026-01-30 16:59:22', '2026-01-31 05:56:17', 'active', '1.0', NULL, 'medium');
INSERT INTO `RULES` (`id`, `title`, `description`, `rule_content`, `created_by`, `created_at`, `updated_at`, `status`, `version`, `category`, `priority`) VALUES (2, 'Kony Backend', 'dsfgdsfg', 'fdgfdgfdgfdgf', NULL, '2026-01-31 12:10:36', '2026-01-31 12:10:36', 'active', '1.0', 'logic', 'medium');

-- Structure for table: USER
CREATE TABLE `USER` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `ruleaccess` varchar(50) NOT NULL DEFAULT 'user',
  `phonenumber` varchar(20) DEFAULT NULL,
  `emailaddress` varchar(255) NOT NULL,
  `state` varchar(100) DEFAULT NULL,
  `address` text,
  `savedpromptlimit` int DEFAULT '100',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `emailaddress` (`emailaddress`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table: USER
INSERT INTO `USER` (`id`, `username`, `password`, `status`, `ruleaccess`, `phonenumber`, `emailaddress`, `state`, `address`, `savedpromptlimit`, `created_at`, `updated_at`) VALUES (1, 'Ashwath', 'password123', 'active', 'admin', '6382084679', 'ashwathsaravanan@gmail.com', 'India', '123 Main St, Los Angeles', 100, '2026-01-30 16:59:21', '2026-01-30 16:59:21');

-- Structure for table: chats
CREATE TABLE `chats` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `ix_chats_id` (`id`),
  CONSTRAINT `chats_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `USER` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table: chats
INSERT INTO `chats` (`id`, `title`, `created_at`, `user_id`) VALUES (1, 'generate ui and formcontroller...', '2026-01-30 18:23:09', NULL);
INSERT INTO `chats` (`id`, `title`, `created_at`, `user_id`) VALUES (2, 'HI...', '2026-01-31 08:53:07', NULL);
INSERT INTO `chats` (`id`, `title`, `created_at`, `user_id`) VALUES (3, 'HI...', '2026-01-31 09:18:18', NULL);
INSERT INTO `chats` (`id`, `title`, `created_at`, `user_id`) VALUES (4, 'hi...', '2026-01-31 13:01:03', NULL);
INSERT INTO `chats` (`id`, `title`, `created_at`, `user_id`) VALUES (5, '[Attached image: e3dd9948fa257...', '2026-01-31 13:48:15', NULL);
INSERT INTO `chats` (`id`, `title`, `created_at`, `user_id`) VALUES (6, '[Attached image: e3dd9948fa257...', '2026-01-31 14:01:33', NULL);

-- Structure for table: messages
CREATE TABLE `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role` varchar(50) DEFAULT NULL,
  `content` text,
  `created_at` datetime DEFAULT NULL,
  `chat_id` int DEFAULT NULL,
  `attachments` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`),
  KEY `ix_messages_id` (`id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table: messages
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (1, 'user', 'generate ui and formcontroller', '2026-01-30 18:23:40', 1, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (2, 'bot', 'Okay, following the KONY Application Development Standards strictly, I will generate a UI definition for a form and its corresponding FormController.

Let''s create a "User Profile" screen (`frmUserProfile`) which allows viewing and editing user details.

---

### KONY UI Definition: `frmUserProfile`

This represents how you would configure the form and its widgets in Kony Visualizer. I''ll provide a programmatic-style representation focusing on key properties, using common Kony widgets and layout principles (FlexLayout).

**Form Name:** `frmUserProfile`

```javascript
// --- KONY UI DEFINITION (frmUserProfile) ---

// Define the Form itself
frmUserProfile = new kony.ui.Form({
    "id": "frmUserProfile",
    "title": "User Profile",
    "enabledForIdleTimeout": false,
    "init": "frmUserProfileController.init", // Associate controller''s init
    "preShow": "frmUserProfileController.preShow", // Associate controller''s preShow
    "postShow": "frmUserProfileController.postShow", // Associate controller''s postShow
    "layoutType": kony.flex.FREE_FORM, // Can also be FLOW_VERTICAL for simpler forms
    "skin": "sknFrmBg", // Example skin for form background
    "addWidgets": function(form) {
        form.add([
            // --- HEADER CONTAINER ---
            new kony.ui.FlexContainer({
                "id": "flxHeader",
                "isVisible": true,
                "height": "8%",
                "left": "0dp",
                "top": "0dp",
                "width": "100%",
                "layoutType": kony.flex.FREE_FORM, // Or FLOW_HORIZONTAL for simple header
                "skin": "sknFlxHeader", // Example skin for header background
                "zIndex": 1,
                "clipBounds": true,
                "addWidgets": function(flxHeader) {
                    flxHeader.add([
                        new kony.ui.Label({
                            "id": "lblFormTitle",
                            "isVisible": true,
                            "left": "20dp",
                            "top": "0dp",
                            "bottom": "0dp",
                            "width": kony.flex.USE_PREFERRED_SIZE,
                            "height": kony.flex.USE_PREFERRED_SIZE,
                            "centerX": "50%",
                            "centerY": "50%",
                            "text": "User Profile",
                            "skin": "sknLblHeaderTitle", // Example skin for title text
                            "textStyle": {
                                "letterSpacing": 0,
                                "strikeThrough": false
                            }
                        }, {}, {}),
                        new kony.ui.Button({
                            "id": "btnEditSave",
                            "isVisible": true,
                            "right": "20dp",
                            "top": "0dp",
                            "bottom": "0dp",
                            "width": "60dp",
                            "height": "auto",
                            "text": "Edit", // Initial text
                            "onClick": "frmUserProfileController.onEditSaveClick", // Associate click handler
                            "skin": "sknBtnHeaderAction", // Example skin for button
                            "focusSkin": "sknBtnHeaderActionFocus"
                        }, {}, {})
                    ]);
                }
            }, {}, {}),

            // --- VIEW MODE CONTAINER (Initially visible) ---
            new kony.ui.FlexContainer({
                "id": "flxViewMode",
                "isVisible": true,
                "left": "0dp",
                "top": "8%", // Below header
                "width": "100%",
                "height": kony.flex.USE_PREFERRED_SIZE,
                "minHeight": "40%", // Or fixed height if content is predictable
                "layoutType": kony.flex.FLOW_VERTICAL,
                "skin": "sknFlxWhiteBg", // Example skin
                "zIndex": 1,
                "padding": [20, 20, 20, 20], // Padding around content
                "addWidgets": function(flxViewMode) {
                    flxViewMode.add([
                        new kony.ui.Label({
                            "id": "lblViewNameLabel",
                            "isVisible": true,
                            "text": "Name:",
                            "skin": "sknLblFieldHeader"
                        }, {}, {}),
                        new kony.ui.Label({
                            "id": "lblViewNameValue",
                            "isVisible": true,
                            "text": "John Doe",
                            "skin": "sknLblFieldValue",
                            "padding": [0, 0, 0, 10] // Bottom padding
                        }, {}, {}),

                        new kony.ui.Label({
                            "id": "lblViewEmailLabel",
                            "isVisible": true,
                            "text": "Email:",
                            "skin": "sknLblFieldHeader"
                        }, {}, {}),
                        new kony.ui.Label({
                            "id": "lblViewEmailValue",
                            "isVisible": true,
                            "text": "john.doe@example.com",
                            "skin": "sknLblFieldValue",
                            "padding": [0, 0, 0, 10]
                        }, {}, {}),

                        new kony.ui.Label({
                            "id": "lblViewPhoneLabel",
                            "isVisible": true,
                            "text": "Phone:",
                            "skin": "sknLblFieldHeader"
                        }, {}, {}),
                        new kony.ui.Label({
                            "id": "lblViewPhoneValue",
                            "isVisible": true,
                            "text": "+1-555-123-4567",
                            "skin": "sknLblFieldValue",
                            "padding": [0, 0, 0, 10]
                        }, {}, {})
                    ]);
                }
            }, {}, {}),

            // --- EDIT MODE CONTAINER (Initially hidden) ---
            new kony.ui.FlexContainer({
                "id": "flxEditMode",
                "isVisible": false, // Initially hidden
                "left": "0dp",
                "top": "8%", // Below header, same position as flxViewMode
                "width": "100%",
                "height": kony.flex.USE_PREFERRED_SIZE,
                "minHeight": "40%",
                "layoutType": kony.flex.FLOW_VERTICAL,
                "skin": "sknFlxWhiteBg",
                "zIndex": 1,
                "padding": [20, 20, 20, 20],
                "addWidgets": function(flxEditMode) {
                    flxEditMode.add([
                        new kony.ui.Label({
                            "id": "lblEditNameLabel",
                            "isVisible": true,
                            "text": "Name:",
                            "skin": "sknLblFieldHeader"
                        }, {}, {}),
                        new kony.ui.TextBox2({
                            "id": "txtEditName",
                            "isVisible": true,
                            "width": "100%",
                            "height": "40dp",
                            "text": "John Doe",
                            "placeholder": "Enter full name",
                            "skin": "sknTxtInput",
                            "focusSkin": "sknTxtInputFocus",
                            "autoCapitalize": kony.text.AUTOCAPITALIZE_WORDS,
                            "maxTextLength": 50,
                            "padding": [10, 10, 10, 10],
                            "bottom": "15dp" // Margin bottom
                        }, {}, {}),

                        new kony.ui.Label({
                            "id": "lblEditEmailLabel",
                            "isVisible": true,
                            "text": "Email:",
                            "skin": "sknLblFieldHeader"
                        }, {}, {}),
                        new kony.ui.TextBox2({
                            "id": "txtEditEmail",
                            "isVisible": true,
                            "width": "100%",
                            "height": "40dp",
                            "text": "john.doe@example.com",
                            "placeholder": "Enter email address",
                            "skin": "sknTxtInput",
                            "focusSkin": "sknTxtInputFocus",
                            "autoCapitalize": kony.text.AUTOCAPITALIZE_NONE,
                            "textInputMode": constants.TEXTBOX_INPUT_MODE_EMAIL,
                            "maxTextLength": 100,
                            "padding": [10, 10, 10, 10],
                            "bottom": "15dp"
                        }, {}, {}),

                        new kony.ui.Label({
                            "id": "lblEditPhoneLabel",
                            "isVisible": true,
                            "text": "Phone:",
                            "skin": "sknLblFieldHeader"
                        }, {}, {}),
                        new kony.ui.TextBox2({
                            "id": "txtEditPhone",
                            "isVisible": true,
                            "width": "100%",
                            "height": "40dp",
                            "text": "+1-555-123-4567",
                            "placeholder": "Enter phone number",
                            "skin": "sknTxtInput",
                            "focusSkin": "sknTxtInputFocus",
                            "textInputMode": constants.TEXTBOX_INPUT_MODE_TEL,
                            "maxTextLength": 20,
                            "padding": [10, 10, 10, 10],
                            "bottom": "15dp"
                        }, {}, {}),

                        new kony.ui.Button({
                            "id": "btnCancel",
                            "isVisible": true,
                            "top": "15dp",
                            "left": "0dp",
                            "width": "100%",
                            "height": "45dp",
                            "text": "Cancel",
                            "onClick": "frmUserProfileController.onCancelClick", // Associate click handler
                            "skin": "sknBtnSecondary", // Example secondary button skin
                            "focusSkin": "sknBtnSecondaryFocus"
                        }, {}, {})
                    ]);
                }
            }, {}, {})
        ]);
    }
}, {
    "displayOrientation": constants.FORM_DISPLAY_ORIENTATION_PORTRAIT,
    "layoutType": kony.flex.FREE_FORM
}, {
    // Platform specific properties (e.g., iOS, Android)
    "retainScrollPosition": false,
    "windowSoftInputMode": constants.FORM_ADJUST_RESIZE
});
```

---

### KONY FormController: `frmUserProfileController.js`

This file will contain the logic for the `frmUserProfile`.

**File Name:** `frmUserProfileController.js`

```javascript
/**
 * @module frmUserProfileController
 * @description Controller for frmUserProfile.
 * Manages view/edit mode of user profile.
 *
 * KONY Application Development Standards:
 * - Use define for AMD module pattern.
 * - Structure with lifecycle methods (init, preShow, postShow).
 * - Encapsulate complex logic in private helper functions (prefixed with `_`).
 * - Use try-catch for error handling in asynchronous operations.
 * - Use kony.application.showLoadingScreen/dismissLoadingScreen for API calls.
 * - Delegate business logic to services/managers (mocked here).
 * - Clear/reset form state in preShow for consistent user experience.
 * - Use meaningful widget IDs and variable names.
 */
define([
    ''ProfileManager'' // Assuming a ProfileManager module exists for data operations
], function(ProfileManager) { // ProfileManager is a mock/placeholder
    /**
     * @class frmUserProfileController
     * @augments kony.mvc.Controller
     */
    return {
        _isEditMode: false,
        _originalProfileData: null, // To store data before editing for cancellation

        /**
         * @function init
         * @description Controller lifecycle event. Called once when the form is initialized.
         * Good place for initial setup, event subscriptions, or one-time data loading.
         */
        init: function() {
            kony.print("frmUserProfileController: init - Form initialized.");
            // Example of dynamic event attachment (if not set in Visualizer)
            // this.view.btnEditSave.onClick = this.onEditSaveClick.bind(this);
            // this.view.btnCancel.onClick = this.onCancelClick.bind(this);
        },

        /**
         * @function preShow
         * @description Controller lifecycle event. Called every time before the form is displayed.
         * Best place to reset form state, populate dynamic content, or perform setup before rendering.
         */
        preShow: function() {
            kony.print("frmUserProfileController: preShow - Preparing form for display.");
            this._resetFormState();
            this._loadUserProfileData(); // Load data initially in view mode
        },

        /**
         * @function postShow
         * @description Controller lifecycle event. Called every time after the form is displayed.
         * Useful for post-rendering tasks, animations, or focusing widgets.
         */
        postShow: function() {
            kony.print("frmUserProfileController: postShow - Form displayed.");
            // Example: Set initial focus if needed
            // this.view.txtEditName.setFocus(true);
        },

        /**
         * @function _resetFormState
         * @private
         * @description Resets the form to its initial view mode state.
         */
        _resetFormState: function() {
            kony.print("frmUserProfileController: Resetting form state.");
            this._isEditMode = false;
            this.view.flxViewMode.isVisible = true;
            this.view.flxEditMode.isVisible = false;
            this.view.btnEditSave.text = "Edit";
            this.view.lblFormTitle.text = "User Profile";
            this._originalProfileData = null; // Clear original data
        },

        /**
         * @function _loadUserProfileData
         * @private
         * @description Fetches and populates the user profile data into the view.
         */
        _loadUserProfileData: async function() {
            kony.application.showLoadingScreen(null, "Loading profile...", constants.LOADING_SCREEN_POSITION_FULL_SCREEN, true, true, null);
            try {
                // Mocking an asynchronous service call
                const userData = await ProfileManager.fetchUserProfile();
                kony.print("frmUserProfileController: User data loaded:", JSON.stringify(userData));

                this.view.lblViewNameValue.text = userData.name;
                this.view.lblViewEmailValue.text = userData.email;
                this.view.lblViewPhoneValue.text = userData.phone;

                // Also populate edit fields (they are hidden, but ready)
                this.view.txtEditName.text = userData.name;
                this.view.txtEditEmail.text = userData.email;
                this.view.txtEditPhone.text = userData.phone;

                this._originalProfileData = userData; // Store for cancellation
            } catch (error) {
                kony.print("frmUserProfileController: Error loading user profile: " + error.message);
                kony.ui.Alert({
                    message: "Failed to load profile. Please try again later.",
                    alertType: constants.ALERT_TYPE_ERROR,
                    alertTitle: "Error",
                    yesHandler: null
                }, {});
            } finally {
                kony.application.dismissLoadingScreen();
            }
        },

        /**
         * @function _updateUserProfileData
         * @private
         * @description Collects data from edit fields and attempts to update the profile.
         */
        _updateUserProfileData: async function() {
            const updatedData = {
                name: this.view.txtEditName.text.trim(),
                email: this.view.txtEditEmail.text.trim(),
                phone: this.view.txtEditPhone.text.trim()
            };

            if (!this._validateProfileData(updatedData)) {
                return; // Validation failed, message already shown
            }

            kony.application.showLoadingScreen(null, "Saving profile...", constants.LOADING_SCREEN_POSITION_FULL_SCREEN, true, true, null);
            try {
                // Mocking an asynchronous service call to update
                await ProfileManager.updateUserProfile(updatedData);
                kony.print("frmUserProfileController: User data updated successfully.");

                kony.ui.Alert({
                    message: "Profile updated successfully!",
                    alertType: constants.ALERT_TYPE_INFO,
                    alertTitle: "Success",
                    yesHandler: null
                }, {});

                this._toggleEditMode(false); // Switch back to view mode
                this._loadUserProfileData(); // Reload to ensure view is updated
            } catch (error) {
                kony.print("frmUserProfileController: Error updating user profile: " + error.message);
                kony.ui.Alert({
                    message: "Failed to save profile. " + error.message,
                    alertType: constants.ALERT_TYPE_ERROR,
                    alertTitle: "Error",
                    yesHandler: null
                }, {});
            } finally {
                kony.application.dismissLoadingScreen();
            }
        },

        /**
         * @function _validateProfileData
         * @private
         * @description Performs client-side validation on profile data.
         * @param {object} data - The profile data object.
         * @returns {boolean} True if data is valid, false otherwise.
         */
        _validateProfileData: function(data) {
            if (!data.name) {
                kony.ui.Alert({ message: "Name cannot be empty.", alertType: constants.ALERT_TYPE_ERROR }, {});
                return false;
            }
            if (!data.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(data.email)) {
                kony.ui.Alert({ message: "Please enter a valid email address.", alertType: constants.ALERT_TYPE_ERROR }, {});
                return false;
            }
            // Basic phone validation (can be more complex with regex)
            if (!data.phone || !/^\+?[0-9\s\-]{7,20}$/.test(data.phone)) {
                kony.ui.Alert({ message: "Please enter a valid phone number.", alertType: constants.ALERT_TYPE_ERROR }, {});
                return false;
            }
            return true;
        },

        /**
         * @function onEditSaveClick
         * @description Event handler for the Edit/Save button.
         */
        onEditSaveClick: function() {
            kony.print("frmUserProfileController: Edit/Save button clicked. Current mode: " + (this._isEditMode ? "Edit" : "View"));
            if (this._isEditMode) {
                // Currently in edit mode, so "Save" was clicked
                this._updateUserProfileData();
            } else {
                // Currently in view mode, so "Edit" was clicked
                this._toggleEditMode(true);
            }
        },

        /**
         * @function onCancelClick
         * @description Event handler for the Cancel button in edit mode.
         */
        onCancelClick: function() {
            kony.print("frmUserProfileController: Cancel button clicked.");
            if (this._originalProfileData) {
                // Restore original data to edit fields
                this.view.txtEditName.text = this._originalProfileData.name;
                this.view.txtEditEmail.text = this._originalProfileData.email;
                this.view.txtEditPhone.text = this._originalProfileData.phone;
            }
            this._toggleEditMode(false); // Switch back to view mode
        },

        /**
         * @function _toggleEditMode
         * @private
         * @description Toggles between view and edit modes for the profile.
         * @param {boolean} enableEdit - True to enable edit mode, false to enable view mode.
         */
        _toggleEditMode: function(enableEdit) {
            this._isEditMode = enableEdit;
            this.view.flxViewMode.isVisible = !enableEdit;
            this.view.flxEditMode.isVisible = enableEdit;

            if (enableEdit) {
                this.view.btnEditSave.text = "Save";
                this.view.lblFormTitle.text = "Edit Profile";
                // Optionally set focus to the first editable field
                this.view.txtEditName.setFocus(true);
            } else {
                this.view.btnEditSave.text = "Edit";
                this.view.lblFormTitle.text = "User Profile";
            }
            kony.print("frmUserProfileController: Switched to " + (enableEdit ? "Edit" : "View") + " mode.");
        }
    };
});

// --- Mock ProfileManager (for demonstration purposes, in a real app, this would be a separate file) ---
// ProfileManager.js
/*
define([], function() {
    let mockUserData = {
        name: "John Doe",
        email: "john.doe@example.com",
        phone: "+1-555-123-4567"
    };

    return {
        fetchUserProfile: function() {
            return new Promise(resolve => {
                setTimeout(() => {
                    kony.print("ProfileManager: Mock data fetched.");
                    resolve({ ...mockUserData }); // Return a copy
                }, 1000);
            });
        },
        updateUserProfile: function(newData) {
            return new Promise((resolve, reject) => {
                setTimeout(() => {
                    // Simulate API success/failure
                    if (Math.random() < 0.9) { // 90% success rate
                        mockUserData = { ...mockUserData, ...newData };
                        kony.print("ProfileManager: Mock data updated:", JSON.stringify(mockUserData));
                        resolve(mockUserData);
                    } else {
                        kony.print("ProfileManager: Mock update failed.");
                        reject(new Error("Network error or server unavailable."));
                    }
                }, 1500);
            });
        }
    };
});
*/
```', '2026-01-30 18:23:41', 1, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (3, 'user', 'HI', '2026-01-31 08:53:10', 2, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (4, 'bot', 'Hi there! How can I help you today?', '2026-01-31 08:53:10', 2, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (5, 'user', 'HI', '2026-01-31 09:18:21', 3, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (6, 'bot', 'Hi there! How can I help you today?', '2026-01-31 09:18:21', 3, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (7, 'user', 'HI IM MOULI', '2026-01-31 09:19:47', 3, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (8, 'bot', 'Hi Mouli! It''s nice to meet you. How can I help you today?', '2026-01-31 09:19:47', 3, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (9, 'user', 'GENERATE THE UI AND CONTROLLER', '2026-01-31 09:20:31', 3, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (10, 'bot', 'Hi Mouli,

Excellent! I understand you''re looking to generate UI and Controller code following the official KONY (now Temenos Digital) platform development standards and best practices. That''s a great approach to ensure maintainability, performance, and scalability.

To help me "GENERATE THE UI AND CONTROLLER" effectively and adhere strictly to those standards, I need a bit more detail about what you''re trying to build. Think of me as your Kony Architect/Developer asking for the requirements.

Please provide the following information:

**For the UI Generation (Form/Component):**

1.  **What is the purpose of this UI?** (e.g., "User Login Form", "Product Details Screen", "List of Orders", "Custom Header Component", "Registration Flow Step").
2.  **What are the key elements/widgets you envision?** (e.g., Text Boxes for username/password, Buttons for Login/Submit, Labels for titles, a Segment/ListBox to display data, Images, Checkboxes, Sliders, a Map).
3.  **What is the overall layout/structure?** (e.g., "A header, a main content area with form fields, and a footer with navigation buttons," or "A scrollable list of items").
4.  **Are there any specific styling or branding requirements?** (e.g., "Use Kony default theme," or "Primary button should be blue," "Form fields should have rounded borders").
5.  **Is this a standalone Form, a reusable Component, or a Template for a Segment?**
6.  **What are the expected user interactions?** (e.g., "Clicking a button navigates to another form," "Entering text validates input," "Selecting an item in a list shows details").

**For the Controller Generation:**

1.  **What data does this UI need to display or manage?** (e.g., "User credentials," "Product name, description, price," "List of order IDs and statuses").
2.  **Where does this data come from?** (e.g., "From a Kony Fabric/Temenos Digital backend service," "Local storage," "Static data"). If it''s a service, do you have the service ID and operation name?
3.  **What business logic or validation needs to occur?** (e.g., "Validate email format," "Check if password meets complexity requirements," "Filter a list based on user input," "Calculate a total").
4.  **What actions should the controller handle?** (e.g., "On form load, fetch data," "On button click, call a service to submit data," "On text change, validate input").
5.  **What navigation is involved?** (e.g., "After successful login, navigate to `frmDashboard`," "On cancel, go back to previous form").

Once I have these details, I can provide you with a structured Kony UI definition (either FFI or a conceptual setup for Visualizer) and a corresponding Controller module, complete with best practices for:

*   **Modularity and Reusability (Components, Templates)**
*   **Separation of Concerns (UI, Business Logic, Data Access)**
*   **MVVM/MVC Architecture adherence**
*   **Event Handling**
*   **Service Integration (Kony Fabric/Temenos Digital)**
*   **Data Binding (if applicable)**
*   **Error Handling**
*   **Performance considerations**

Looking forward to your input, Mouli! Let''s build something great, adhering to those strict Kony standards.', '2026-01-31 09:20:31', 3, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (11, 'user', 'GENERATE THE UI AND CONTROLLER ', '2026-01-31 09:24:09', 2, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (12, 'bot', 'I understand you want to generate UI and Controller code adhering to Kony Application Development Standards.

However, the input you provided is the **title** of the standards document itself:
`### KONY Application Development Standards Official KONY platform development standards and best practices`

To generate meaningful UI and Controller code, I need more information about **what specific UI and functionality you want to create**.

Please tell me:

1.  **What kind of screen or feature do you want to build?** (e.g., a Login Screen, a Product List, a User Profile, a Registration Form, a Dashboard).
2.  **What specific UI elements should it include?** (e.g., text inputs, buttons, labels, images, segments, maps).
3.  **What functionality should the Controller handle?** (e.g., form validation, API calls, navigation, data binding).
4.  **Do you have any specific Kony widgets or layout preferences in mind?**

Once you provide these details, I can generate the UI (forms, widgets, layout) and Controller (logic, event handlers) code, incorporating general Kony best practices. If you have a specific section of the "KONY Application Development Standards" you''d like me to reference, please provide that as well.

**Example Request:**
"Generate a simple Kony login screen. It should have two text boxes for ''Username'' and ''Password'', a ''Login'' button, and a ''Forgot Password?'' label. The controller should include basic validation (check if fields are not empty) and simulate a successful login message."', '2026-01-31 09:24:09', 2, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (13, 'user', 'HELLO', '2026-01-31 10:10:39', 2, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (14, 'bot', 'You''ve provided "HELLO" as your input, which is a greeting.

To generate UI and Controller code, I need to understand **what kind of UI and functionality you want to build**. "HELLO" doesn''t give me enough information to create anything specific.

Please tell me:

1.  **What screen or feature are you trying to create?** (e.g., a simple welcome screen, a form, a list, a button).
2.  **What UI elements should be present?** (e.g., a label, a button, a text input, an image).
3.  **What should the Controller do?** (e.g., handle a button click, display a message, navigate to another screen).

**For example, you could say:**

*   "Generate a simple welcome screen with a label that says ''Welcome to Kony App!'' and a button that says ''Start''."
*   "Create a UI with a text input field and a button. The controller should display the text from the input field in an alert when the button is clicked."

Once you provide these details, I can generate the Kony-style UI and Controller code for you!', '2026-01-31 10:10:39', 2, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (15, 'user', '[Attached image: e3dd9948fa25737a832e1688c0571484.jpg]

generate the ui and code controller ', '2026-01-31 12:17:32', 3, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (16, 'bot', 'Okay, Mouli! Based on the image you provided, which depicts a **"Sign Up"** screen with fields for Full Name, Email, Password, Confirm Password, a "Sign Up" button, and a "Login" link, I will generate the UI structure and Controller code following Kony (Temenos Digital) development standards and best practices.

**Core Principles Adhered To:**

1.  **MVVM/MVC Separation:** The UI (Form definition) is separate from the logic (Controller).
2.  **Modularity:** Form-specific controller.
3.  **Widget Naming Conventions:** Clear, descriptive IDs (e.g., `flx`, `lbl`, `txt`, `btn`).
4.  **Layout & Responsiveness:** Use Flex Containers for structured and responsive design.
5.  **Skins:** Emphasize the use of skins for consistent look and feel (though specific skin definitions are conceptual here).
6.  **Event Handling:** Proper attachment of actions to UI events.
7.  **Validation:** Client-side validation for improved UX.
8.  **Service Integration:** Placeholder for Kony Fabric service calls.
9.  **Loading Indicators & Error Handling:** Best practices for user feedback.
10. **Navigation:** Clear navigation actions.

---

### 1. Kony Visualizer UI Structure (Conceptual `frmSignUp`)

This describes how you would set up the form and its widgets in Kony Visualizer.

**Form: `frmSignUp`**
*   **ID:** `frmSignUp`
*   **Layout Type:** `kony.flex.FLOW_VERTICAL` (for overall vertical stacking)
*   **Enable Scrolling:** `true` (important for forms on smaller screens)
*   **PreShow Event:** Link to `frmSignUpController.onFormPreShow`

---

#### **Header Container: `flxHeader`**
*   **ID:** `flxHeader`
*   **Type:** `FlexContainer`
*   **Layout Type:** `kony.flex.FREE_FORM`
*   **Top:** `0dp`
*   **Left:** `0dp`
*   **Right:** `0dp`
*   **Height:** `56dp` (Standard header height)
*   **Skin:** `sknFlxHeaderBG` (e.g., Light grey background, bottom border)
    *   **Child Widget:**
        *   **Label: `lblHeaderTitle`**
            *   **ID:** `lblHeaderTitle`
            *   **Text:** "Sign Up"
            *   **Skin:** `sknLblHeaderTitle` (e.g., #333333, bold, font size 140%)
            *   **CenterX:** `50%`
            *   **CenterY:** `50%`

---

#### **Main Content Container: `flxMainContent`**
*   **ID:** `flxMainContent`
*   **Type:** `FlexContainer`
*   **Layout Type:** `kony.flex.FLOW_VERTICAL`
*   **Top:** `56dp` (Below header)
*   **Left:** `0dp`
*   **Right:** `0dp`
*   **Bottom:** `0dp`
*   **Padding:** `[20, 20, 20, 20]` (for inner spacing)
*   **Skin:** `sknFlxWhiteBG` (e.g., White background)

    *   **Child Widgets (within `flxMainContent`):**

    1.  **TextBox: `txtFullName`**
        *   **ID:** `txtFullName`
        *   **Placeholder:** "Full Name"
        *   **Skin:** `sknTxtInputDefault` (e.g., border, rounded corners, padding)
        *   **Top:** `20dp`
        *   **Height:** `45dp`
        *   **Width:** `100%`
        *   **Text Input Mode:** `kony.flex.FORM_STD_TEXTBOX`
        *   **Auto Capitalize:** `kony.flex.TEXTBOX_AUTO_CAPITALIZE_WORDS`
        *   **OnTextChange Event:** Link to `frmSignUpController.onFullNameTextChange`
        *   **Error Label (below): `lblErrorFullName`**
            *   **ID:** `lblErrorFullName`
            *   **Text:** "" (Initially empty)
            *   **IsVisible:** `false`
            *   **Skin:** `sknLblError` (e.g., Red text, smaller font)
            *   **Top:** `5dp`
            *   **Width:** `100%`

    2.  **TextBox: `txtEmail`**
        *   **ID:** `txtEmail`
        *   **Placeholder:** "Email"
        *   **Skin:** `sknTxtInputDefault`
        *   **Top:** `15dp`
        *   **Height:** `45dp`
        *   **Width:** `100%`
        *   **Text Input Mode:** `kony.flex.FORM_EMAIL_TEXTBOX`
        *   **Auto Capitalize:** `kony.flex.TEXTBOX_AUTO_CAPITALIZE_NONE`
        *   **OnTextChange Event:** Link to `frmSignUpController.onEmailTextChange`
        *   **Error Label (below): `lblErrorEmail`**
            *   **ID:** `lblErrorEmail`
            *   **Text:** ""
            *   **IsVisible:** `false`
            *   **Skin:** `sknLblError`
            *   **Top:** `5dp`
            *   **Width:** `100%`

    3.  **TextBox: `txtPassword`**
        *   **ID:** `txtPassword`
        *   **Placeholder:** "Password"
        *   **Skin:** `sknTxtInputDefault`
        *   **Top:** `15dp`
        *   **Height:** `45dp`
        *   **Width:** `100%`
        *   **Secure Text Entry:** `true`
        *   **Text Input Mode:** `kony.flex.FORM_PASSWORD_TEXTBOX`
        *   **OnTextChange Event:** Link to `frmSignUpController.onPasswordTextChange`
        *   **Error Label (below): `lblErrorPassword`**
            *   **ID:** `lblErrorPassword`
            *   **Text:** ""
            *   **IsVisible:** `false`
            *   **Skin:** `sknLblError`
            *   **Top:** `5dp`
            *   **Width:** `100%`

    4.  **TextBox: `txtConfirmPassword`**
        *   **ID:** `txtConfirmPassword`
        *   **Placeholder:** "Confirm Password"
        *   **Skin:** `sknTxtInputDefault`
        *   **Top:** `15dp`
        *   **Height:** `45dp`
        *   **Width:** `100%`
        *   **Secure Text Entry:** `true`
        *   **Text Input Mode:** `kony.flex.FORM_PASSWORD_TEXTBOX`
        *   **OnTextChange Event:** Link to `frmSignUpController.onConfirmPasswordTextChange`
        *   **Error Label (below): `lblErrorConfirmPassword`**
            *   **ID:** `lblErrorConfirmPassword`
            *   **Text:** ""
            *   **IsVisible:** `false`
            *   **Skin:** `sknLblError`
            *   **Top:** `5dp`
            *   **Width:** `100%`

    5.  **Button: `btnSignUp`**
        *   **ID:** `btnSignUp`
        *   **Text:** "Sign Up"
        *   **Skin:** `sknBtnPrimary` (e.g., Blue background, white text, rounded)
        *   **Focus Skin:** `sknBtnPrimaryFocus`
        *   **Disable Skin:** `sknBtnPrimaryDisabled`
        *   **Top:** `30dp`
        *   **Height:** `50dp`
        *   **Width:** `90%`
        *   **CenterX:** `50%`
        *   **IsEnabled:** `false` (Initially disabled)
        *   **OnClick Event:** Link to `frmSignUpController.onSignUpClick`

    6.  **Login Link Container: `flxLoginLink`**
        *   **ID:** `flxLoginLink`
        *   **Type:** `FlexContainer`
        *   **Layout Type:** `kony.flex.FLOW_HORIZONTAL`
        *   **Top:** `20dp`
        *   **Height:** `30dp`
        *   **Width:** `kony.flex.USE_PREFERRED_SIZE`
        *   **CenterX:** `50%`
            *   **Child Widgets (within `flxLoginLink`):**
                *   **Label: `lblAlreadyAccount`**
                    *   **ID:** `lblAlreadyAccount`
                    *   **Text:** "Already have an account?"
                    *   **Skin:** `sknLblDefault` (e.g., Grey text)
                    *   **Left:** `0dp`
                    *   **CenterY:** `50%`
                *   **Button: `btnLinkLogin`**
                    *   **ID:** `btnLinkLogin`
                    *   **Text:** "Login"
                    *   **Skin:** `sknBtnLinkPrimary` (e.g., Blue text, underlined, transparent background)
                    *   **Left:** `5dp`
                    *   **CenterY:** `50%`
                    *   **OnClick Event:** Link to `frmSignUpController.onLoginClick`

---

#### **Conceptual Skins (Define these in Visualizer Themes)**

*   **`sknFlxHeaderBG`**: `background-color: #F8F8F8; border-bottom: 1px solid #E0E0E0;`
*   **`sknLblHeaderTitle`**: `font-weight: 700; font-size: 140%; text-align: center; color: #333333;`
*   **`sknFlxWhiteBG`**: `background-color: #FFFFFF;`
*   **`sknTxtInputDefault`**: `border: 1px solid #CCCCCC; border-radius: 5dp; padding: [10,10,10,10]; background-color: #FFFFFF; font-color: #333333;`
*   **`sknLblError`**: `font-color: #FF0000; font-size: 80%; padding: [0,5,0,5];`
*   **`sknBtnPrimary`**: `background-color: #007AFF; border-radius: 5dp; font-color: #FFFFFF; font-size: 120%; font-weight: 600;`
*   **`sknBtnPrimaryFocus`**: (e.g., darker blue for pressed state)
*   **`sknBtnPrimaryDisabled`**: `background-color: #BDBDBD; font-color: #EEEEEE;`
*   **`sknLblDefault`**: `font-color: #666666; font-size: 90%;`
*   **`sknBtnLinkPrimary`**: `font-color: #007AFF; font-size: 90%; text-decoration: underline; background-color: transparent;`

---

### 2. Kony Controller Code (`controllers/mobile/frmSignUpController/frmSignUpController.js`)

This JavaScript file will contain the logic for the `frmSignUp` form.

```javascript
/**
 * @module frmSignUpController
 * @description Controller for the frmSignUp form.
 * Adheres to Kony (Temenos Digital) best practices for UI and business logic separation.
 */
define({

    /**
     * @property {Object} _validationRules
     * @description Stores validation rules for each input field.
     */
    _validationRules: {
        fullName: {
            minLength: 3,
            errorMessage: "Full Name must be at least 3 characters."
        },
        email: {
            regex: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
            errorMessage: "Please enter a valid email address."
        },
        password: {
            minLength: 8,
            regex: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$/,
            errorMessage: "Password must be 8+ chars, with uppercase, lowercase, number, and special char."
        }
        // Confirm password is validated against password field directly
    },

    /**
     * @method onFormPreShow
     * @description Called before the form is displayed. Initializes UI and state.
     */
    onFormPreShow: function() {
        this.resetForm();
        this.view.btnSignUp.skin = "sknBtnPrimaryDisabled"; // Ensure button is disabled
        this.view.btnSignUp.setEnabled(false);
    },

    /**
     * @method resetForm
     * @description Resets all form fields and error messages.
     */
    resetForm: function() {
        this.view.txtFullName.text = "";
        this.view.txtEmail.text = "";
        this.view.txtPassword.text = "";
        this.view.txtConfirmPassword.text = "";
        this.clearErrorMessages();
    },

    /**
     * @method clearErrorMessages
     * @description Hides all error labels and clears their text.
     */
    clearErrorMessages: function() {
        this.view.lblErrorFullName.text = "";
        this.view.lblErrorFullName.isVisible = false;
        this.view.lblErrorEmail.text = "";
        this.view.lblErrorEmail.isVisible = false;
        this.view.lblErrorPassword.text = "";
        this.view.lblErrorPassword.isVisible = false;
        this.view.lblErrorConfirmPassword.text = "";
        this.view.lblErrorConfirmPassword.isVisible = false;
    },

    /**
     * @method onFullNameTextChange
     * @description Event handler for Full Name text input.
     */
    onFullNameTextChange: function() {
        this._validateField(this.view.txtFullName, this.view.lblErrorFullName, ''fullName'');
        this._toggleSignUpButton();
    },

    /**
     * @method onEmailTextChange
     * @description Event handler for Email text input.
     */
    onEmailTextChange: function() {
        this._validateField(this.view.txtEmail, this.view.lblErrorEmail, ''email'');
        this._toggleSignUpButton();
    },

    /**
     * @method onPasswordTextChange
     * @description Event handler for Password text input.
     */
    onPasswordTextChange: function() {
        this._validateField(this.view.txtPassword, this.view.lblErrorPassword, ''password'');
        this._validateConfirmPassword(); // Re-validate confirm password if password changes
        this._toggleSignUpButton();
    },

    /**
     * @method onConfirmPasswordTextChange
     * @description Event handler for Confirm Password text input.
     */
    onConfirmPasswordTextChange: function() {
        this._validateConfirmPassword();
        this._toggleSignUpButton();
    },

    /**
     * @private
     * @method _validateField
     * @description Generic helper to validate a single text input based on rules.
     * @param {kony.ui.TextBox} textBoxWidget - The TextBox widget instance.
     * @param {kony.ui.Label} errorLabelWidget - The Label widget to display errors.
     * @param {string} ruleKey - Key to lookup validation rules in _validationRules.
     * @returns {boolean} True if valid, false otherwise.
     */
    _validateField: function(textBoxWidget, errorLabelWidget, ruleKey) {
        const text = textBoxWidget.text.trim();
        const rules = this._validationRules[ruleKey];
        let isValid = true;
        let errorMessage = "";

        if (text === "") {
            isValid = false;
            errorMessage = `Please enter your ${ruleKey.replace(/([A-Z])/g, '' $1'').toLowerCase()}.`; // e.g., "full name"
        } else if (rules.minLength && text.length < rules.minLength) {
            isValid = false;
            errorMessage = rules.errorMessage;
        } else if (rules.regex && !rules.regex.test(text)) {
            isValid = false;
            errorMessage = rules.errorMessage;
        }

        this._showError(errorLabelWidget, errorMessage, !isValid);
        return isValid;
    },

    /**
     * @private
     * @method _validateConfirmPassword
     * @description Specific validation for confirm password field.
     * @returns {boolean} True if valid, false otherwise.
     */
    _validateConfirmPassword: function() {
        const password = this.view.txtPassword.text;
        const confirmPassword = this.view.txtConfirmPassword.text;
        let isValid = true;
        let errorMessage = "";

        if (confirmPassword === "") {
            isValid = false;
            errorMessage = "Please confirm your password.";
        } else if (password !== confirmPassword) {
            isValid = false;
            errorMessage = "Passwords do not match.";
        }

        this._showError(this.view.lblErrorConfirmPassword, errorMessage, !isValid);
        return isValid;
    },

    /**
     * @private
     * @method _showError
     * @description Displays or hides an error message for a given label.
     * @param {kony.ui.Label} errorLabelWidget - The Label widget to update.
     * @param {string} message - The error message to display.
     * @param {boolean} isVisible - Whether the label should be visible.
     */
    _showError: function(errorLabelWidget, message, isVisible) {
        errorLabelWidget.text = message;
        errorLabelWidget.isVisible = isVisible;
    },

    /**
     * @private
     * @method _isFormValid
     * @description Checks if all form fields are currently valid.
     * @returns {boolean} True if all fields are valid, false otherwise.
     */
    _isFormValid: function() {
        const isFullNameValid = this._validateField(this.view.txtFullName, this.view.lblErrorFullName, ''fullName'');
        const isEmailValid = this._validateField(this.view.txtEmail, this.view.lblErrorEmail, ''email'');
        const isPasswordValid = this._validateField(this.view.txtPassword, this.view.lblErrorPassword, ''password'');
        const isConfirmPasswordValid = this._validateConfirmPassword();

        return isFullNameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid;
    },

    /**
     * @private
     * @method _toggleSignUpButton
     * @description Enables/disables the Sign Up button based on form validity.
     */
    _toggleSignUpButton: function() {
        if (this._isFormValid()) {
            this.view.btnSignUp.setEnabled(true);
            this.view.btnSignUp.skin = "sknBtnPrimary";
        } else {
            this.view.btnSignUp.setEnabled(false);
            this.view.btnSignUp.skin = "sknBtnPrimaryDisabled";
        }
    },

    /**
     * @method onSignUpClick
     * @description Event handler for the Sign Up button click.
     */
    onSignUpClick: function() {
        if (this._isFormValid()) {
            kony.application.showLoadingScreen(null, "Signing up...", constants.LOADING_SCREEN_STYLE_ICON_AND_TEXT, true, true, null);

            const fullName = this.view.txtFullName.text;
            const email = this.view.txtEmail.text;
            const password = this.view.txtPassword.text;

            // --- Kony Fabric Service Integration Placeholder ---
            // Assuming a Kony Fabric Identity Service or Object Service for User creation.
            // Replace with actual service details.

            const authClient = kony.sdk.getCurrentInstance().get</td>
</tr>
</tbody>
</table>
</code></pre></div>
</div>
</div>
</div>
</div>
</div>', '2026-01-31 12:17:32', 3, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (17, 'user', 'hi', '2026-01-31 13:01:06', 4, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (18, 'bot', 'Hello! How can I help you today?', '2026-01-31 13:01:06', 4, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (19, 'user', '[Attached image: e3dd9948fa25737a832e1688c0571484.jpg]

genertate ui and controller', '2026-01-31 13:03:21', 4, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (20, 'bot', 'Okay, I''ve analyzed the attached image, which appears to be a login/sign-up screen for a mobile application.

Based on the visual elements, here''s a conceptual UI structure and the corresponding controller logic you would typically implement. This description is general and can be adapted to various mobile development frameworks (like Kony/Temenos Quantum, React Native, Flutter, native Android/iOS, etc.).

---

### UI (User Interface) Generation

The UI can be broken down into a series of stacked components within a main container, likely a `Form` or `ScrollView` to handle potential keyboard overlaps.

**1. Main Container (Screen):**
*   A `View` or `Screen` component that fills the entire display.
*   Could include a `ScrollView` if the content might exceed screen height on smaller devices, especially when the keyboard is active.
*   Background color: White.

**2. Header Section:**
*   **Title:** A `Text` component displaying "Login" (or "Sign In") centered at the top.
*   **(Optional/Implied):** A back arrow or close button on the top left, though not visible in this specific screenshot, is common for such screens.

**3. Logo/Branding Section:**
*   **Image:** A circular `Image` component containing the letter ''T'' (presumably a logo or avatar placeholder). This would be centered horizontally.

**4. Input Fields Section:**
*   **Username/Email Input:**
    *   `Text` component (Label): "Username"
    *   `TextInput` (or `Kony TextField`/`UITextField`/`EditText`):
        *   Placeholder: "Enter your username" (or "Email")
        *   Input Type: Text, potentially email-address type for better keyboard.
        *   Styling: Clear border (possibly just bottom border), white background.
*   **Password Input:**
    *   `Text` component (Label): "Password"
    *   `TextInput` (or `Kony TextField`/`UITextField`/`EditText`):
        *   Placeholder: "Enter your password"
        *   Input Type: Password (secure text entry to hide characters).
        *   Styling: Clear border, white background.

**5. Action Links Section:**
*   **Forgot Password Link:**
    *   `TextButton` or `Link` component: "Forgot Password?"
    *   Styling: Smaller font size, possibly a different color to indicate it''s a clickable link, aligned to the right.

**6. Primary Action Button:**
*   **Login Button:**
    *   `Button` component: "Login"
    *   Styling: Prominent background color (e.g., blue or a brand color), full width, white text, rounded corners.

**7. Secondary Action / Sign-up Prompt:**
*   **Sign Up Prompt:**
    *   A `View` containing two `Text` components or a `Text` component with a nested `TextButton`/`Link`.
    *   `Text`: "Don''t have an account? "
    *   `TextButton` or `Link`: "Sign up"
    *   Styling: Centered horizontally, smaller font size. The "Sign up" part is usually distinguishable by color or bolding, indicating it''s clickable.

---

### Controller Logic Generation

The controller (or ViewModel/Presenter, depending on your architecture) will handle the interactions, data management, and navigation for this screen.

**1. State Management:**
*   `username` (string): Stores the current value of the username/email input field.
*   `password` (string): Stores the current value of the password input field.
*   `isLoading` (boolean): Controls loading indicator display during login attempt.
*   `errorMessage` (string): Stores any error message to display to the user.

**2. Event Handlers:**

*   **`onUsernameChange(text)`:**
    *   Updates the `username` state with the new `text` value.
*   **`onPasswordChange(text)`:**
    *   Updates the `password` state with the new `text` value.
*   **`onLoginPress()`:**
    *   **Input Validation:**
        *   Check if `username` and `password` fields are not empty.
        *   (Optional) Validate username format (e.g., email regex if it''s an email field).
        *   If validation fails, set `errorMessage` state and return.
    *   **Loading State:** Set `isLoading` to `true`.
    *   **Backend Call (e.g., Kony Fabric/Integration Service):**
        *   Call an authentication API (e.g., `/auth/login` or a Kony Identity service).
        *   Pass `username` and `password` as parameters.
    *   **Response Handling:**
        *   **On Success:**
            *   Store user session/token (e.g., in secure storage).
            *   Clear `errorMessage`.
            *   Navigate to the main application screen (e.g., `HomeScreen`).
        *   **On Failure:**
            *   Parse error response from the backend.
            *   Set `errorMessage` state with a user-friendly message (e.g., "Invalid credentials", "Network error").
            *   (Optional) Clear `password` field for security.
    *   **Finally:** Set `isLoading` to `false`.
*   **`onForgotPasswordPress()`:**
    *   Navigate to the "Forgot Password" screen (e.g., `navigation.navigate(''ForgotPassword'')`).
*   **`onSignUpPress()`:**
    *   Navigate to the "Sign Up" screen (e.g., `navigation.navigate(''SignUp'')`).

**3. Utility Functions (Internal):**
*   **`validateInputs()`:** A helper function that encapsulates the validation logic for `onLoginPress()`.

This structured approach allows for clear separation of concerns, making the UI descriptive and the controller robust and testable.', '2026-01-31 13:03:21', 4, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (21, 'user', 'genertate ui and controller', '2026-01-31 13:04:35', 4, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (22, 'bot', 'Okay, I''ve analyzed the attached image, which depicts a Login screen for a mobile application. Following Kony''s official development standards and best practices, here''s how you would structure the UI and implement the controller logic.

---

### KONY UI Generation (Form `frmLogin`)

We will create a Kony `Form` named `frmLogin`. The layout will primarily use `FlexContainer` widgets for structure, adhering to best practices for responsive UI.

**Form Structure:**

*   **Form ID:** `frmLogin`
*   **Layout Type:** `kony.flex.FREE_FORM` (or `kony.flex.FLOW_VERTICAL` if preferring a stacked approach for the main body).
*   **Properties:** `bounces: false`, `scrollDirection: kony.flex.SCROLL_VERTICAL` (if content might exceed screen height, especially with keyboard).
*   **Event:** `postShow` (to attach event listeners, clear previous errors, etc.)

---

**Widget Hierarchy and Properties:**

```
frmLogin (kony.ui.Form)
└── flxMainContainer (kony.ui.FlexContainer) - Fills the form, acts as main scrollable content holder if needed.
    └── flxHeader (kony.ui.FlexContainer)
        ├── lblLoginTitle (kony.ui.Label)
    └── flxLogoContainer (kony.ui.FlexContainer)
        ├── imgLogo (kony.ui.Image)
    └── flxInputContainer (kony.ui.FlexContainer)
        ├── lblUsername (kony.ui.Label)
        ├── txtUsername (kony.ui.TextBox2)
        ├── lblPassword (kony.ui.Label)
        ├── txtPassword (kony.ui.TextBox2)
        ├── lblError (kony.ui.Label) - For displaying validation/API errors
    └── flxForgotPassword (kony.ui.FlexContainer)
        ├── btnForgotPassword (kony.ui.Button) - Styled as a link
    └── btnLogin (kony.ui.Button)
    └── flxSignUpContainer (kony.ui.FlexContainer)
        ├── rchtxtSignUpPrompt (kony.ui.RichText)
```

---

**Detailed Widget Properties (Conceptual):**

1.  **`frmLogin`** (`kony.ui.Form`)
    *   `id: frmLogin`
    *   `layoutType: kony.flex.FREE_FORM`
    *   `enableScrolling: true` (if content might scroll)
    *   `onPostShow: AS_Form_d1f2g3h4i5j6` (links to controller function)

2.  **`flxMainContainer`** (`kony.ui.FlexContainer`)
    *   `id: flxMainContainer`
    *   `left: "0dp"`, `top: "0dp"`, `width: "100%"`, `height: "100%"`, `zIndex: 1`
    *   `layoutType: kony.flex.FLOW_VERTICAL`
    *   `skin: sknFlxWhiteBG` (A white background skin)
    *   `autogrowMode: kony.flex.AUTOGROW_HEIGHT` (if child content varies)

3.  **`flxHeader`** (`kony.ui.FlexContainer`)
    *   `id: flxHeader`
    *   `left: "0dp"`, `top: "0dp"`, `width: "100%"`, `height: "50dp"`
    *   `layoutType: kony.flex.FREE_FORM`
    *   `skin: sknFlxWhiteBG` (Or `sknFlxHeader`)
    *   `centerX: "50%"` (if centering the whole header)

4.  **`lblLoginTitle`** (`kony.ui.Label`)
    *   `id: lblLoginTitle`
    *   `text: "Login"`
    *   `centerX: "50%"`, `centerY: "50%"`
    *   `skin: sknLblHeaderTitle` (e.g., `fontColor: #000000`, `fontSize: 120%`, `fontWeight: BOLD`)

5.  **`flxLogoContainer`** (`kony.ui.FlexContainer`)
    *   `id: flxLogoContainer`
    *   `width: "100%"`, `height: "120dp"`
    *   `layoutType: kony.flex.FREE_FORM`
    *   `top: "30dp"` (spacing after header)
    *   `skin: sknFlxTransparent`

6.  **`imgLogo`** (`kony.ui.Image`)
    *   `id: imgLogo`
    *   `src: "your_logo_t.png"` (or placeholder image)
    *   `centerX: "50%"`, `centerY: "50%"`
    *   `width: "80dp"`, `height: "80dp"`
    *   `skin: sknImgCircle` (A skin with `borderType: CIRCLE`, `borderThickness: 1dp`, `borderColor: #cccccc`)
    *   `imageScaleMode: kony.flex.IMAGE_SCALE_MODE_FIT_TO_DIMENSIONS`

7.  **`flxInputContainer`** (`kony.ui.FlexContainer`)
    *   `id: flxInputContainer`
    *   `width: "85%"`, `height: kony.flex.USE_PREFERRED_SIZE` (`autogrowMode: kony.flex.AUTOGROW_HEIGHT`)
    *   `centerX: "50%"`, `top: "30dp"`
    *   `layoutType: kony.flex.FLOW_VERTICAL`
    *   `skin: sknFlxTransparent`

8.  **`lblUsername`** (`kony.ui.Label`)
    *   `id: lblUsername`
    *   `text: "Username"`
    *   `left: "0dp"`, `top: "15dp"`
    *   `skin: sknLblInputLabel`

9.  **`txtUsername`** (`kony.ui.TextBox2`)
    *   `id: txtUsername`
    *   `placeholder: "Enter your username"`
    *   `width: "100%"`, `height: "45dp"`
    *   `left: "0dp"`, `top: "5dp"`
    *   `skin: sknTxtInputDefault` (e.g., `backgroundColor: #FFFFFF`, `borderType: LINE`, `borderThickness: 1dp`, `borderColor: #CCCCCC`, `borderRadius: 5dp`)
    *   `focusSkin: sknTxtInputFocus` (e.g., `borderColor: #007AFF`)
    *   `autoCapitalize: KONY_TEXTBOX_AUTO_CAPITALIZE_NONE`
    *   `keyboardType: KONY_KEYBOARD_TYPE_EMAIL` (if it''s an email)
    *   `onTextChange: AS_TextField_txtUsernameChange` (optional, can read on login button click)

10. **`lblPassword`** (`kony.ui.Label`)
    *   `id: lblPassword`
    *   `text: "Password"`
    *   `left: "0dp"`, `top: "15dp"`
    *   `skin: sknLblInputLabel`

11. **`txtPassword`** (`kony.ui.TextBox2`)
    *   `id: txtPassword`
    *   `placeholder: "Enter your password"`
    *   `width: "100%"`, `height: "45dp"`
    *   `left: "0dp"`, `top: "5dp"`
    *   `skin: sknTxtInputDefault`, `focusSkin: sknTxtInputFocus`
    *   `secureTextEntry: true`
    *   `onTextChange: AS_TextField_txtPasswordChange` (optional)

12. **`lblError`** (`kony.ui.Label`)
    *   `id: lblError`
    *   `text: "" ` (Initially empty)
    *   `isVisible: false` (initially)
    *   `left: "0dp"`, `top: "10dp"`
    *   `skin: sknLblError` (e.g., `fontColor: #FF0000`, `fontSize: 80%`)

13. **`flxForgotPassword`** (`kony.ui.FlexContainer`)
    *   `id: flxForgotPassword`
    *   `width: "85%"`, `height: kony.flex.USE_PREFERRED_SIZE`
    *   `centerX: "50%"`, `top: "10dp"`
    *   `layoutType: kony.flex.FREE_FORM`
    *   `skin: sknFlxTransparent`

14. **`btnForgotPassword`** (`kony.ui.Button`)
    *   `id: btnForgotPassword`
    *   `text: "Forgot Password?"`
    *   `right: "0dp"`, `top: "0dp"`
    *   `width: kony.flex.USE_PREFERRED_SIZE`, `height: kony.flex.USE_PREFERRED_SIZE`
    *   `skin: sknBtnLinkSmall` (e.g., `fontColor: #007AFF`, `fontSize: 80%`, `textDecoration: NONE`)
    *   `focusSkin: sknBtnLinkSmallFocus`
    *   `onClick: AS_Button_forgotPasswordClick`

15. **`btnLogin`** (`kony.ui.Button`)
    *   `id: btnLogin`
    *   `text: "Login"`
    *   `width: "85%"`, `height: "50dp"`
    *   `centerX: "50%"`, `top: "30dp"`
    *   `skin: sknBtnPrimary` (e.g., `backgroundColor: #007AFF`, `fontColor: #FFFFFF`, `borderRadius: 5dp`)
    *   `focusSkin: sknBtnPrimaryFocus`
    *   `onClick: AS_Button_loginClick`

16. **`flxSignUpContainer`** (`kony.ui.FlexContainer`)
    *   `id: flxSignUpContainer`
    *   `width: "100%"`, `height: kony.flex.USE_PREFERRED_SIZE`
    *   `centerX: "50%"`, `top: "30dp"`
    *   `layoutType: kony.flex.FREE_FORM`
    *   `skin: sknFlxTransparent`

17. **`rchtxtSignUpPrompt`** (`kony.ui.RichText`)
    *   `id: rchtxtSignUpPrompt`
    *   `text: "Don''t have an account? <a href=\"signup\"><b>Sign up</b></a>"`
    *   `centerX: "50%"`, `centerY: "50%"`
    *   `width: kony.flex.USE_PREFERRED_SIZE`, `height: kony.flex.USE_PREFERRED_SIZE`
    *   `skin: sknRchTxtNormal` (e.g., `fontColor: #333333`, `fontSize: 90%`)
    *   `linkSkin: sknRchTxtLink` (for the "Sign up" part, e.g., `fontColor: #007AFF`)
    *   `onClick: AS_RichText_signupClick` (when the link is clicked)

---

### KONY Controller Logic Generation (`frmLoginController.js`)

This controller will manage the `frmLogin` form.

**File:** `modules/frmLoginController.js` (or `controllers/FormControllers/frmLoginController.js` in newer Quantum versions)

```javascript
define([''ValidateUtil'', ''SessionManager''], function(ValidateUtil, SessionManager) {

  return {
    /**
     * @property {string} username - Holds the current username/email from the input.
     */
    username: "",
    /**
     * @property {string} password - Holds the current password from the input.
     */
    password: "",

    /**
     * Constructor for the Login Controller.
     */
    onInit: function() {
      // Any initial setup for the controller goes here
      kony.print("frmLoginController: Initialized.");
    },

    /**
     * lifecycle event - Called when the form is navigated to.
     * @param {Object} context - Optional data passed during navigation.
     */
    onNavigate: function(context) {
      kony.print("frmLoginController: Navigated.");
      // Optional: If you expect any context data, handle it here.
    },

    /**
     * lifecycle event - Called after the form is rendered and visible.
     */
    onPostShow: function() {
      kony.print("frmLoginController: PostShow event.");
      this.clearLoginForm();
      this.initActions();
    },

    /**
     * Clears the input fields and any error messages on form load.
     */
    clearLoginForm: function() {
      this.view.txtUsername.text = "";
      this.view.txtPassword.text = "";
      this.view.lblError.text = "";
      this.view.lblError.isVisible = false;
      this.username = "";
      this.password = "";
      kony.application.dismissLoadingScreen(); // Ensure no loading screen is stuck
    },

    /**
     * Attaches event listeners to the widgets.
     */
    initActions: function() {
      this.view.btnLogin.onClick = this.onLoginClick;
      this.view.btnForgotPassword.onClick = this.onForgotPasswordClick;
      // For RichText, the `onClick` will fire for the entire widget. We need to parse the link ID.
      this.view.rchtxtSignUpPrompt.onClick = this.onSignUpClick;
      // Optional: Input change handlers if you need real-time validation or state updates
      this.view.txtUsername.onTextChange = this.onUsernameTextChange;
      this.view.txtPassword.onTextChange = this.onPasswordTextChange;
    },

    /**
     * Event handler for username text change.
     * @param {Object} widget - The TextBox2 widget.
     */
    onUsernameTextChange: function(widget) {
      this.username = widget.text;
      this.view.lblError.isVisible = false; // Hide error on input change
    }.bind(this),

    /**
     * Event handler for password text change.
     * @param {Object} widget - The TextBox2 widget.
     */
    onPasswordTextChange: function(widget) {
      this.password = widget.text;
      this.view.lblError.isVisible = false; // Hide error on input change
    }.bind(this),

    /**
     * Displays an error message on the form.
     * @param {string} message - The error message to display.
     */
    showError: function(message) {
      this.view.lblError.text = message;
      this.view.lblError.isVisible = true;
    },

    /**
     * Event handler for the Login button click.
     */
    onLoginClick: function() {
      kony.print("frmLoginController: Login button clicked.");

      this.username = this.view.txtUsername.text; // Read latest value
      this.password = this.view.txtPassword.text; // Read latest value

      // 1. Input Validation
      if (!ValidateUtil.isValidInput(this.username)) {
        this.showError("Please enter your username.");
        return;
      }
      if (!ValidateUtil.isValidInput(this.password)) {
        this.showError("Please enter your password.");
        return;
      }
      // Optional: More complex validation (e.g., email format for username)
      // if (this.username.includes(''@'') && !ValidateUtil.isValidEmail(this.username)) {
      //   this.showError("Please enter a valid email address.");
      //   return;
      // }

      // 2. Show Loading Indicator
      kony.application.showLoadingScreen(null, "Logging in...", constants.LOADING_SCREEN_IMAGE_FLX, true, true, {});

      // 3. Make Backend Service Call (e.g., Kony Fabric Identity Service)
      try {
        const authClient = kony.sdk.getCurrentInstance().get</span><span class="s3">IdentityService</span><span class="s2">(</span><span class="s0">"userstore"</span><span class="s2">); </span><span class="s1">// Replace "userstore" with your Kony Fabric Identity Service name

        const loginOptions = {
          "userid": this.username,
          "password": this.password,
          "loginOptions": {
            "is       </span><span class="s3">RememberMeEnabled</span><span class="s2">: false </span><span class="s1">// Or true based on requirement
          }
        };

        authClient.login(loginOptions,
          (response) => {
            // Success Callback
            kony.application.dismissLoadingScreen();
            kony.print("Login successful: " + JSON.stringify(response));

            // Store session/user data (e.g., using a helper module)
            SessionManager.storeUserSession(response);

            // Navigate to the main dashboard form
            new kony.mvc.Navigation("frmDashboard").navigate();
          },
          (error) => {
            // Failure Callback
            kony.application.dismissLoadingScreen();
            kony.print("Login failed: " + JSON.stringify(error));
            let errorMessage = "Login failed. Please try again.";
            if (error && error.error_response) {
              errorMessage = error.error_response.message || errorMessage;
            } else if (error && error.message) {
              errorMessage = error.message;
            }
            this.showError(errorMessage);
            this.view.txtPassword.text = ""; // Clear password on failure for security
          }
        );
      } catch (e) {
        kony.application.dismissLoadingScreen();
        kony.print("Error during login service call: " + e.message);
        this.showError("An unexpected error occurred. Please try again later.");
      }
    }.bind(this), // Bind ''this'' to the controller instance

    /**
     * Event handler for Forgot Password button click.
     */
    onForgotPasswordClick: function() {
      kony.print("frmLoginController: Forgot Password clicked.");
      // Navigate to Forgot Password form
      new kony.mvc.Navigation("frmForgotPassword").navigate();
    }.bind(this),

    /**
     * Event handler for Sign Up link click (from RichText).
     * @param {Object} widget - The RichText widget.
     * @param {string} linkId - The ID of the clicked link (e.g., "signup").
     */
    onSignUpClick: function(widget, linkId) {
      if (linkId === "signup") {
        kony.print("frmLoginController: Sign Up link clicked.");
        // Navigate to Sign Up form
        new kony.mvc.Navigation("frmSignUp").navigate();
      }
    }.bind(this)
  };
});
```

---

**Helper Modules (Conceptual):**

You''d typically have helper modules for common functionalities:

1.  **`ValidateUtil.js`** (`modules/ValidateUtil.js`)
    ```javascript
    define([], function() {
      return {
        isValidInput: function(text) {
          return text && text.trim().length > 0;
        },
        isValidEmail: function(email) {
          // Basic email regex
          const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
          return regex.test(email);
        }
      };
    });
    ```
2.  **`SessionManager.js`** (`modules/SessionManager.js`)
    ```javascript
    define([], function() {
      return {
        storeUserSession: function(userData) {
          // Example: Store user ID or auth token in kony.store or kony.security.util
          kony.store.setItem("userId", userData.userid);
          kony.store.setItem("authToken", userData.authToken); // Assuming token is part of response
          kony.print("User session stored.");
        },
        getUserSession: function() {
          return {
            userId: kony.store.getItem("userId"),
            authToken: kony.store.getItem("authToken")
          };
        },
        clearUserSession: function() {
          kony.store.removeItem("userId");
          kony.store.removeItem("authToken");
          kony.print("User session cleared.");
        }
      };
    });
    ```

---

**Kony Best Practices Applied:**

*   **MVC Architecture:** Clear separation of UI (Form, Widgets, Skins) and Logic (Controller).
*   **Skins:** Extensive use of skins for consistent look and feel, and easy theming/branding.
*   **FlexLayout:** Using `FlexContainer` for responsive and adaptable UI.
*   **Modularization:** Breaking down logic into reusable modules (e.g., `ValidateUtil`, `SessionManager`).
*   **Event Handling:** Using widget `onClick`, `onTextChange`, and form lifecycle events (`onPostShow`).
*   **Loading Indicators:** Providing user feedback during network operations.
*   **Error Handling:** Displaying user-friendly error messages and logging detailed errors.
*   **Kony Fabric Integration:** Utilizing `kony.sdk.getCurrentInstance().getIdentityService()` for authentication.
*   **Secure Input:** `secureTextEntry: true` for password fields.
*   **Navigation:** Using `new kony.mvc.Navigation("FormName").navigate()`.
*   **`bind(this)`:** Ensuring the correct `this` context within event handlers.

This comprehensive structure ensures maintainability, scalability, and adherence to Kony''s development standards.', '2026-01-31 13:04:36', 4, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (23, 'user', '[Attached image: e3dd9948fa25737a832e1688c0571484.jpg]

generate the controller', '2026-01-31 13:48:34', 5, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (24, 'bot', 'Based on the Kony Application Development Standards illustrated in your image (Form -> View Model -> Controller -> Service/Navigation), here''s a template for a Kony (now HCL Volt MX) controller.

This example assumes:
*   A form named `frmLogin`.
*   Input fields for `username` and `password` on `frmLogin` (e.g., `txtUsername`, `txtPassword`).
*   A `Button` for login (`btnLogin`).
*   A `Label` to display error messages (`lblErrorMessage`).
*   An associated `ViewModel` that holds the data for these widgets.
*   A `LoginService` that handles authentication.

---

### KONY Application Development Standards: Controller Implementation

```javascript
/**
 * @class frmLoginController
 * @description Controller for the frmLogin form.
 *              Handles user interactions, updates the View Model,
 *              makes service calls, and manages navigation.
 */
define([''module''], function (module) {

    /**
     * @constructor
     * @param {Object} baseConfig - Base configuration for the controller.
     * @param {Object} layoutConfig - Layout configuration for the controller.
     * @param {Object} pConfig - Parent configuration for the controller.
     */
    function frmLoginController(baseConfig, layoutConfig, pConfig) {
        // Call the parent constructor (Presenter)
        kony.mvc.MDAApplication.getAppInstance().get.	(this, frmLoginController);

        this.view = baseConfig.view; // Reference to the form/view
        this.viewModel = this.view.getViewModel(); // Reference to the form''s View Model

        // Initialize event handlers
        this._bindEvents();
    }

    // Define prototype methods for the controller
    kony.mvc.util.extend(frmLoginController.prototype, {

        /**
         * @method _bindEvents
         * @description Binds events to the form''s widgets.
         *              This is a private helper method.
         */
        _bindEvents: function () {
            // Attach event listener to the Login Button
            if (this.view.btnLogin) {
                this.view.btnLogin.onClick = this.onClickLogin.bind(this);
            }
            // Optionally, clear error message when username/password fields are focused
            if (this.view.txtUsername) {
                this.view.txtUsername.onBeginEditing = this.clearErrorMessage.bind(this);
            }
            if (this.view.txtPassword) {
                this.view.txtPassword.onBeginEditing = this.clearErrorMessage.bind(this);
            }
        },

        /**
         * @method onNavigate
         * @description Called when the form is navigated to.
         *              Handles any data passed during navigation or initial data setup.
         * @param {Object} context - Data passed during navigation.
         */
        onNavigate: function (context) {
            kony.print("frmLoginController: onNavigate called with context: " + JSON.stringify(context));
            // Initialize View Model properties to ensure clean state
            this.viewModel.username = "";
            this.viewModel.password = "";
            this.viewModel.errorMessage = "";
            this.view.lblErrorMessage.skin = "sknLblError"; // Ensure error skin is applied
            this.view.forceLayout(); // Refresh UI after View Model updates
        },

        /**
         * @method onClickLogin
         * @description Event handler for the Login button.
         *              Gets user input from View Model, performs validation,
         *              makes a service call, and handles the response.
         */
        onClickLogin: function () {
            kony.print("frmLoginController: onClickLogin called.");

            // Clear any previous error messages
            this.clearErrorMessage();

            // 1. Get data from View Model (which is data-bound to the form''s input widgets)
            const username = this.viewModel.username;
            const password = this.viewModel.password;

            // 2. Perform client-side validation
            if (!username || username.trim() === "") {
                this.showErrorMessage("Username cannot be empty.");
                return;
            }
            if (!password || password.trim() === "") {
                this.showErrorMessage("Password cannot be empty.");
                return;
            }

            // 3. Prepare payload for service call
            const payload = {
                "username": username,
                "password": password
            };

            // 4. Show loading indicator (if using a common component or utility)
            kony.application.showLoadingScreen(null, "Logging in...", constants.LOADING_SCREEN_IMAGE_POSITION_FULL_SCREEN, true, true, {});

            // 5. Make the service call using the Business Controller/Manager
            //    Access the Business Controller/Manager via the MDAApplication instance
            kony.mvc.MDAApplication.getAppInstance().get. -->ManagerForPresent	er("AuthModule").login(payload,
                this._onLoginSuccess.bind(this), // Success callback
                this._onLoginFailure.bind(this) // Failure callback
            );
        },

        /**
         * @method _onLoginSuccess
         * @description Callback for a successful login service response.
         * @param {Object} response - The success response from the service.
         *              This is a private helper method.
         */
        _onLoginSuccess: function (response) {
            kony.print("frmLoginController: _onLoginSuccess called. Response: " + JSON.stringify(response));
            kony.application.dismissLoadingScreen();

            if (response && response.status === "success") {
                // 1. Update View Model if necessary (e.g., store user token, profile data)
                //    For simplicity, we''re just navigating.
                // this.viewModel.userToken = response.userToken;

                // 2. Navigate to the next form (e.g., Dashboard)
                //    Using kony.mvc.Navigation for standard MVC navigation
                new kony.mvc.Navigation({
                    "formName": "frmDashboard"
                }).navigate();

                // Clear login fields after successful login
                this.viewModel.username = "";
                this.viewModel.password = "";
                this.view.forceLayout();
            } else {
                // Handle success but with application-specific error (e.g., wrong credentials message from service)
                this.showErrorMessage(response.message || "Login failed. Please check your credentials.");
            }
        },

        /**
         * @method _onLoginFailure
         * @description Callback for a failed login service response.
         * @param {Object} error - The error response from the service.
         *              This is a private helper method.
         */
        _onLoginFailure: function (error) {
            kony.print("frmLoginController: _onLoginFailure called. Error: " + JSON.stringify(error));
            kony.application.dismissLoadingScreen();

            // Determine appropriate error message
            let errorMessage = "An unexpected error occurred during login.";
            if (error && error.message) {
                errorMessage = error.message;
            } else if (error && error.opstatus === 1000) {
                // Example: Network error or backend not reachable
                errorMessage = "Network error or server is unreachable. Please try again later.";
            }

            // Update View Model with the error message to display on the form
            this.showErrorMessage(errorMessage);
        },

        /**
         * @method showErrorMessage
         * @description Updates the View Model to display an error message on the form.
         *              This is a private helper method.
         * @param {string} message - The error message to display.
         */
        showErrorMessage: function (message) {
            this.viewModel.errorMessage = message;
            this.view.lblErrorMessage.skin = "sknLblError"; // Ensure error skin is applied
            this.view.forceLayout(); // Refresh UI to show the updated message
        },

        /**
         * @method clearErrorMessage
         * @description Clears the error message from the View Model and UI.
         *              This is a private helper method.
         */
        clearErrorMessage: function () {
            this.viewModel.errorMessage = "";
            this.view.lblErrorMessage.skin = "sknLblHidden"; // Apply a skin that hides the label, or just clear text
            this.view.forceLayout(); // Refresh UI
        }

    });

    // Export the controller constructor
    module.exports = frmLoginController;
});
```

---

### Key Points and Adherence to KONY Standards:

1.  **MVC Structure:** The controller (`frmLoginController`) is responsible for handling user input, processing it, making service calls, and orchestrating navigation. It *does not directly manipulate UI widgets* but rather updates the `ViewModel`.
2.  **`define` Module:** The controller is defined as a standard Kony JavaScript module using `define([''module''], function (module) { ... });`.
3.  **Constructor:** The `frmLoginController` constructor initializes the controller, gets references to `this.view` (the form) and `this.viewModel`, and binds events.
4.  **`this.view` and `this.viewModel`:** These are crucial. `this.view` refers to the Kony form/component instance, and `this.viewModel` is the automatically generated ViewModel instance for that form.
5.  **`_bindEvents`:** A private helper method to centralize event binding, typically called once in the constructor. Event handlers (`onClickLogin`) are bound using `.bind(this)` to maintain the correct `this` context.
6.  **`onNavigate(context)`:** This is a standard lifecycle method in Kony controllers, executed when a form is navigated to. It''s ideal for initial data loading or setting up the form''s state based on `context` data.
7.  **Data Flow (Controller -> View Model):** When the controller needs to update the UI (e.g., display an error message, clear input fields), it updates properties on `this.viewModel` (e.g., `this.viewModel.errorMessage = message;`). Kony''s data binding automatically reflects these changes on the form''s widgets (e.g., `lblErrorMessage`).
8.  **Data Flow (View Model -> Controller):** When user inputs data into widgets, if the widgets are data-bound to the ViewModel, the controller can directly access that data from `this.viewModel` (e.g., `const username = this.viewModel.username;`).
9.  **Service Calls:** Kony recommends using Business Controllers/Managers (part of the MDA/MVC framework) for service calls. `kony.mvc.MDAApplication.getAppInstance().get. -->ManagerForPresent	er("AuthModule").login(...)` demonstrates this.
10. **Navigation:** Navigation is handled using `new kony.mvc.Navigation({ "formName": "frmDashboard" }).navigate();`, which is the standard MVC approach.
11. **Loading Indicators:** Standard Kony APIs `kony.application.showLoadingScreen()` and `kony.application.dismissLoadingScreen()` are used for user feedback during asynchronous operations.
12. **Error Handling:** Robust error handling is included for service call failures and client-side validation, with messages displayed via the ViewModel.
13. **Private Helpers (`_prefix`):** Methods like `_bindEvents`, `_onLoginSuccess`, `_onLoginFailure` are prefixed with an underscore to denote them as private helper methods, a common JavaScript convention.', '2026-01-31 13:48:34', 5, NULL);
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (25, 'user', '[Attached image: e3dd9948fa25737a832e1688c0571484.jpg]

generate the form and controller', '2026-01-31 14:02:09', 6, '[{"name": "e3dd9948fa25737a832e1688c0571484.jpg", "type": "image", "content": "data:image/jpeg;base64,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"}]');
INSERT INTO `messages` (`id`, `role`, `content`, `created_at`, `chat_id`, `attachments`) VALUES (26, 'bot', 'Okay, I will generate the Kony Form and Controller based on the provided image and adhere to KONY Application Development Standards.

The image depicts a screen for "Create New Payee" with a header, an input field for "Payee Name", a "CONTINUE" button, and a "Powered by Kony" footer.

---

### KONY Form Definition: `frmCreateNewPayee`

This JavaScript-like structure represents how you would define the form programmatically in Kony (now HCL Volt MX) or how the Visualizer would generate it. It focuses on using `FlexContainer` for layout and standard Kony widgets.

```javascript
// Form Definition: frmCreateNewPayee
// This code snippet is illustrative and typically generated by Kony Visualizer or defined in its properties panel.

var frmCreateNewPayee = new kony.ui.Form({
    "id": "frmCreateNewPayee",
    "init": "frmCreateNewPayeeController.preShow", // Call preShow on form initialization
    "postShow": "frmCreateNewPayeeController.postShow", // Call postShow after form is visible
    "enableScrolling": true,
    "layoutType": kony.flex.FREE_FORM, // Use FREE_FORM for overall flexibility
    "skin": "sknFrmWhiteBg", // A standard skin for form background
    "addWidgets": function(frm) {
        // --- Header Container ---
        var flxHeader = new kony.ui.FlexContainer({
            "id": "flxHeader",
            "isVisible": true,
            "skin": "sknFlxHeader", // A skin for the header background
            "height": "60dp",
            "width": "100%",
            "top": "0dp",
            "left": "0dp",
            "layoutType": kony.flex.FREE_FORM
        }, {}, {});

        var imgBack = new kony.ui.Image2({
            "id": "imgBack",
            "isVisible": true,
            "src": "icon_back_arrow.png", // Placeholder image source
            "height": "24dp",
            "width": "24dp",
            "left": "15dp",
            "centerY": "50%",
            "onTouchEnd": "frmCreateNewPayeeController.onBackClick",
            "imageScaleMode": constants.IMAGE_SCALE_MODE_FIT_TO_DIMENSIONS
        }, {
            "imageScaleMode": constants.IMAGE_SCALE_MODE_FIT_TO_DIMENSIONS,
            "padding": [0, 0, 0, 0]
        }, {});

        var lblHeaderTitle = new kony.ui.Label({
            "id": "lblHeaderTitle",
            "isVisible": true,
            "text": "Create New Payee",
            "skin": "sknLblHeaderTitle", // Skin for header title text
            "centerX": "50%",
            "centerY": "50%",
            "height": kony.flex.USE_PREFERRED_SIZE,
            "width": kony.flex.USE_PREFERRED_SIZE,
            "textStyle": {
                "letterSpacing": 0,
                "strikeThrough": false
            }
        }, {
            "contentAlignment": constants.CONTENT_ALIGN_CENTER,
            "padding": [0, 0, 0, 0]
        }, {});

        var lblProgress = new kony.ui.Label({
            "id": "lblProgress",
            "isVisible": true,
            "text": "1/3",
            "skin": "sknLblProgressIndicator", // Skin for progress text
            "right": "60dp",
            "centerY": "50%",
            "height": kony.flex.USE_PREFERRED_SIZE,
            "width": kony.flex.USE_PREFERRED_SIZE,
            "textStyle": {
                "letterSpacing": 0,
                "strikeThrough": false
            }
        }, {
            "contentAlignment": constants.CONTENT_ALIGN_CENTER,
            "padding": [0, 0, 0, 0]
        }, {});

        var imgClose = new kony.ui.Image2({
            "id": "imgClose",
            "isVisible": true,
            "src": "icon_close.png", // Placeholder image source
            "height": "24dp",
            "width": "24dp",
            "right": "15dp",
            "centerY": "50%",
            "onTouchEnd": "frmCreateNewPayeeController.onCloseClick",
            "imageScaleMode": constants.IMAGE_SCALE_MODE_FIT_TO_DIMENSIONS
        }, {
            "imageScaleMode": constants.IMAGE_SCALE_MODE_FIT_TO_DIMENSIONS,
            "padding": [0, 0, 0, 0]
        }, {});

        flxHeader.add(imgBack, lblHeaderTitle, lblProgress, imgClose);

        // --- Main Content Container ---
        var flxContent = new kony.ui.FlexContainer({
            "id": "flxContent",
            "isVisible": true,
            "skin": "slFbox", // Transparent skin
            "height": kony.flex.USE_PREFERRED_SIZE, // Adjust height based on content
            "width": "100%",
            "top": "60dp", // Below header
            "left": "0dp",
            "layoutType": kony.flex.FLOW_VERTICAL, // Stack elements vertically
            "autogrowMode": kony.flex.AUTOGROW_HEIGHT,
            "bottom": "80dp" // Leave space for the fixed footer
        }, {}, {});

        var lblPayeeName = new kony.ui.Label({
            "id": "lblPayeeName",
            "isVisible": true,
            "text": "Payee Name",
            "skin": "sknLblPrimaryBold", // Skin for label text
            "height": kony.flex.USE_PREFERRED_SIZE,
            "width": "90%",
            "centerX": "50%",
            "top": "20dp",
            "textStyle": {
                "letterSpacing": 0,
                "strikeThrough": false
            }
        }, {
            "contentAlignment": constants.CONTENT_ALIGN_TOP_LEFT,
            "padding": [0, 0, 0, 0]
        }, {});

        var txtPayeeName = new kony.ui.TextBox2({
            "id": "txtPayeeName",
            "isVisible": true,
            "skin": "sknTxtInput", // Skin for text input field
            "focusSkin": "sknTxtInputFocus", // Skin when focused
            "height": "45dp",
            "width": "90%",
            "centerX": "50%",
            "top": "10dp",
            "placeholder": "Enter Payee Name",
            "autoCapitalize": constants.TEXTBOX_AUTO_CAPITALIZE_NONE,
            "keyboardType": constants.KEYBOARD_TYPE_ALPHA_NUMERIC,
            "onTextChange": "frmCreateNewPayeeController.onPayeeNameTextChange",
            "textInputMode": constants.TEXTBOX_INPUT_MODE_ANY
        }, {
            "containerHeightMode": constants.TEXTBOX_FONT_METRICS_ALIGN_BY_TEXT_INPUT,
            "contentAlignment": constants.CONTENT_ALIGN_MIDDLE_LEFT,
            "padding": [5, 3, 0, 3] // Adjust padding as needed
        }, {
            "autoCorrect": false
        });

        flxContent.add(lblPayeeName, txtPayeeName);


        // --- Footer for Buttons ---
        var flxBottomBar = new kony.ui.FlexContainer({
            "id": "flxBottomBar",
            "isVisible": true,
            "skin": "sknFlxBottomBar", // Skin for footer background, usually transparent or slight shadow
            "height": "80dp",
            "width": "100%",
            "bottom": "0dp",
            "left": "0dp",
            "layoutType": kony.flex.FREE_FORM // Use FREE_FORM to position button
        }, {}, {});

        var btnContinue = new kony.ui.Button({
            "id": "btnContinue",
            "isVisible": true,
            "text": "CONTINUE",
            "skin": "sknBtnPrimaryEnabled", // Skin for enabled button
            "focusSkin": "sknBtnPrimaryFocus", // Skin when focused
            "disabledSkin": "sknBtnPrimaryDisabled", // Skin for disabled button
            "height": "50dp",
            "width": "90%",
            "centerX": "50%",
            "centerY": "40%", // Position towards top of footer
            "onClick": "frmCreateNewPayeeController.onContinueClick",
            "zIndex": 1 // Ensure it''s above other elements if any overlap
        }, {
            "contentAlignment": constants.CONTENT_ALIGN_CENTER,
            "displayText": true,
            "padding": [0, 0, 0, 0]
        }, {});

        var lblPoweredBy = new kony.ui.Label({
            "id": "lblPoweredBy",
            "isVisible": true,
            "text": "Powered by Kony",
            "skin": "sknLblSmallGray", // A subtle skin for footer text
            "height": kony.flex.USE_PREFERRED_SIZE,
            "width": kony.flex.USE_PREFERRED_SIZE,
            "centerX": "50%",
            "bottom": "5dp",
            "textStyle": {
                "letterSpacing": 0,
                "strikeThrough": false
            },
            "zIndex": 1
        }, {
            "contentAlignment": constants.CONTENT_ALIGN_CENTER,
            "padding": [0, 0, 0, 0]
        }, {});

        flxBottomBar.add(btnContinue, lblPoweredBy);

        frm.add(flxHeader, flxContent, flxBottomBar);
    }
});
```

**Key Kony Best Practices in Form Definition:**

1.  **FlexLayout:** Primarily uses `FlexContainer` for responsive and dynamic layouts.
2.  **Skins:** Placeholder `skn` values are used for every widget. In a real project, these skins would be defined in the Kony Visualizer and follow a consistent naming convention (e.g., `sknFlxWhiteBg`, `sknLblRed`, `sknBtnPrimary`).
3.  **Modularity:** Separating UI (Form) from logic (Controller).
4.  **`dp` Units:** All dimensions use `dp` (density-independent pixels) for cross-device compatibility.
5.  **`kony.flex.USE_PREFERRED_SIZE` and `AUTOGROW_HEIGHT`:** Used where content dictates size, ensuring flexibility.
6.  **Event Assignment:** `onClick` or `onTouchEnd` events are directly linked to controller functions.
7.  **Image Sources:** `src` properties for images are placeholders and should point to actual resources in your Kony project.
8.  **Form `init` and `postShow`:** Using these lifecycle events to connect to controller functions for initialization and final setup.

---

### KONY Controller Definition: `frmCreateNewPayeeController`

This JavaScript file contains the logic for the `frmCreateNewPayee` form. It adheres to Kony''s modular controller structure.

**File Name:** `modules/frmCreateNewPayeeController.js` (or similar path in your Kony project)

```javascript
define([], function() {
  var frmCreateNewPayeeController = {
    /**
     * @function preShow
     * @description This function is executed before the form is displayed.
     * It''s ideal for setting up initial UI states, data binding, or hiding/showing elements.
     */
    preShow: function() {
      // CommonUtilities.showLoadingIndicator(); // Example: Show loading indicator if data fetch is involved

      // Initialize UI elements
      this.view.txtPayeeName.text = "";
      this.view.btnContinue.setEnabled(false); // Initially disable continue button
      this.view.btnContinue.skin = "sknBtnPrimaryDisabled"; // Apply disabled skin

      // Optional: If you need to refresh data or UI after navigation
      // this.refreshUI();
      // CommonUtilities.dismissLoadingIndicator(); // Example: Dismiss loading
    },

    /**
     * @function postShow
     * @description This function is executed after the form has been rendered and is visible.
     * Useful for post-rendering animations or final UI adjustments.
     */
    postShow: function() {
      // Focus on the input field for immediate user interaction
      this.view.txtPayeeName.setFocus(true);
    },

    /**
     * @function onBackClick
     * @description Handles the click event for the back arrow icon.
     * Navigates to the previous form or dismisses the current flow.
     */
    onBackClick: function() {
      kony.print("Back button clicked");
      // Example: Navigate back to the previous form
      var navManager = applicationManager.getNavigationManager();
      navManager.goBack(); // This assumes a navigation stack is managed
      // Or: new kony.mvc.Navigation("frmPreviousForm").navigate();
    },

    /**
     * @function onCloseClick
     * @description Handles the click event for the close (X) icon.
     * Typically navigates to a dashboard or dismisses the entire workflow.
     */
    onCloseClick: function() {
      kony.print("Close button clicked");
      // Example: Navigate to the dashboard or home screen
      var navManager = applicationManager.getNavigationManager();
      navManager.navigateTo("frmDashboard");
      // Or: new kony.mvc.Navigation("frmDashboard").navigate();
    },

    /**
     * @function onPayeeNameTextChange
     * @description Handles the text change event for the Payee Name input field.
     * Used for real-time validation and enabling/disabling the "CONTINUE" button.
     */
    onPayeeNameTextChange: function() {
      kony.print("Payee Name text changed: " + this.view.txtPayeeName.text);
      let payeeName = this.view.txtPayeeName.text;

      // Basic validation: Check if text is not empty
      if (payeeName && payeeName.trim().length > 0) {
        this.view.btnContinue.setEnabled(true);
        this.view.btnContinue.skin = "sknBtnPrimaryEnabled"; // Apply enabled skin
      } else {
        this.view.btnContinue.setEnabled(false);
        this.view.btnContinue.skin = "sknBtnPrimaryDisabled"; // Apply disabled skin
      }
    },

    /**
     * @function onContinueClick
     * @description Handles the click event for the "CONTINUE" button.
     * Performs final validation and navigates to the next step (step 2/3).
     */
    onContinueClick: function() {
      kony.print("Continue button clicked");
      let payeeName = this.view.txtPayeeName.text.trim();

      if (payeeName.length === 0) {
        // Display an error message if validation fails (e.g., using a Kony popup or alert)
        kony.ui.Alert({
          message: "Payee Name cannot be empty.",
          alertType: constants.ALERT_TYPE_INFO,
          alertTitle: "Validation Error",
          yesLabel: "OK",
          noLabel: "",
          alertHandler: function() {}
        }, {});
        return;
      }

      // Store the payee name in a common module or service for the next screen
      var payeesModule = kony.mvc.MDAApplication.get                  ().get     
                                            ().getModule("PayeesModule"); // Assuming a PayeesModule
      payeesModule.getPresentationController().setNewPayeeName(payeeName); // Example of storing data

      // Navigate to the next step of the "Create New Payee" flow
      var navManager = applicationManager.getNavigationManager();
      navManager.navigateTo("frmCreateNewPayeeStep2"); // Navigate to the next form
      // Or: new kony.mvc.Navigation("frmCreateNewPayeeStep2").navigate();
    },

    /**
     * @function refreshUI
     * @description Example function to refresh the UI elements, if needed during form lifecycle.
     */
    refreshUI: function() {
      // Any UI update logic here
    }
  };

  return frmCreateNewPayeeController;
});
```

**Key Kony Best Practices in Controller Definition:**

1.  **Modular Structure:** Using `define([], function() { ... });` for AMD (Asynchronous Module Definition) ensures the controller is a self-contained module.
2.  **`applicationManager` / `kony.mvc.Navigation`:** Standard Kony (and Volt MX) methods for navigation and managing the application state. `applicationManager` is part of the common framework setup for abstracting services.
3.  **`this.view`:** Accessing form widgets using `this.view.widgetId` within the controller.
4.  **`kony.print()`:** For debugging and logging messages.
5.  **Validation:** Basic input validation is demonstrated, with a placeholder for showing user feedback (e.g., `kony.ui.Alert`).
6.  **`setEnabled()` / `skin`:** Dynamically enabling/disabling buttons and changing skins based on user input for better UX.
7.  **Lifecycle Hooks:** Utilizing `preShow` and `postShow` for proper form initialization and final setup.
8.  **Data Persistence:** Suggestion to use a Presentation Controller or a service module (`payeesModule.getPresentationController().setNewPayeeName`) to pass data between forms, adhering to MVC principles.', '2026-01-31 14:02:09', 6, NULL);

SET FOREIGN_KEY_CHECKS = 1;