BEGIN TRANSACTION;
CREATE TABLE chats (
	id INTEGER NOT NULL, 
	title VARCHAR, 
	created_at DATETIME, 
	user_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES users (id)
);
INSERT INTO "chats" VALUES(1,'hi...','2026-01-28 18:24:06.621219',NULL);
INSERT INTO "chats" VALUES(3,'hello...','2026-01-28 18:24:38.205890',NULL);
INSERT INTO "chats" VALUES(4,'hi...','2026-01-28 18:27:49.093253',NULL);
INSERT INTO "chats" VALUES(7,'Hi gemini...','2026-01-28 18:32:43.763081',NULL);
INSERT INTO "chats" VALUES(8,'generate a formcontroller usin...','2026-01-28 18:33:03.174444',NULL);
INSERT INTO "chats" VALUES(9,'generate ui for kony visuvaliz...','2026-01-28 18:39:16.642289',NULL);
INSERT INTO "chats" VALUES(10,'Hi Hello...','2026-01-28 19:15:03.112166',NULL);
INSERT INTO "chats" VALUES(11,'fghgfh...','2026-01-28 19:15:16.908810',NULL);
INSERT INTO "chats" VALUES(12,'HI...','2026-01-28 21:45:34.489977',NULL);
INSERT INTO "chats" VALUES(13,'hii...','2026-01-30 08:51:10.084363',NULL);
INSERT INTO "chats" VALUES(14,'hello...','2026-01-30 09:03:11.906032',NULL);
INSERT INTO "chats" VALUES(15,'who is delulu ...','2026-01-30 10:42:55.241629',NULL);
INSERT INTO "chats" VALUES(16,'what is the problem in janayag...','2026-01-30 10:43:30.830122',NULL);
INSERT INTO "chats" VALUES(17,'no janayagan is a thalapathi m...','2026-01-30 10:44:29.210048',NULL);
INSERT INTO "chats" VALUES(18,'today current news...','2026-01-30 10:44:55.286477',NULL);
INSERT INTO "chats" VALUES(19,'hello...','2026-01-30 10:45:19.852178',NULL);
INSERT INTO "chats" VALUES(20,'Hi ...','2026-01-30 11:46:02.558945',NULL);
INSERT INTO "chats" VALUES(21,'sdhfsd...','2026-01-30 11:46:31.386077',NULL);
INSERT INTO "chats" VALUES(22,'I don''t have rule...','2026-01-30 11:46:54.866777',NULL);
INSERT INTO "chats" VALUES(23,'`DFGFD...','2026-01-30 12:24:24.941611',NULL);
INSERT INTO "chats" VALUES(24,'hi...','2026-01-30 12:27:09.906413',NULL);
INSERT INTO "chats" VALUES(25,'hnj...','2026-01-30 12:27:25.955714',NULL);
INSERT INTO "chats" VALUES(26,'hi...','2026-01-30 12:33:33.990294',NULL);
INSERT INTO "chats" VALUES(27,'generate a ui and controller...','2026-01-30 12:55:35.875281',NULL);
INSERT INTO "chats" VALUES(28,'sdfg...','2026-01-30 14:26:45.879945',NULL);
INSERT INTO "chats" VALUES(29,'hi there...','2026-01-30 14:43:41.043380',NULL);
CREATE TABLE messages (
	id INTEGER NOT NULL, 
	role VARCHAR, 
	content TEXT, 
	created_at DATETIME, 
	chat_id INTEGER, attachments JSON, 
	PRIMARY KEY (id), 
	FOREIGN KEY(chat_id) REFERENCES chats (id)
);
INSERT INTO "messages" VALUES(1,'user','hi','2026-01-28 18:24:07.352559',1,NULL);
INSERT INTO "messages" VALUES(2,'bot','Gemini Error: 404 models/gemini-1.5-flash is not found for API version v1beta, or is not supported for generateContent. Call ListModels to see the list of available models and their supported methods.','2026-01-28 18:24:07.352559',1,NULL);
INSERT INTO "messages" VALUES(5,'user','hello','2026-01-28 18:24:38.943776',3,NULL);
INSERT INTO "messages" VALUES(6,'bot','Gemini Error: 404 models/gemini-1.5-pro is not found for API version v1beta, or is not supported for generateContent. Call ListModels to see the list of available models and their supported methods.','2026-01-28 18:24:38.943776',3,NULL);
INSERT INTO "messages" VALUES(7,'user','hi','2026-01-28 18:25:30.431323',1,NULL);
INSERT INTO "messages" VALUES(8,'bot','Gemini Error: 404 models/gemini-1.5-pro is not found for API version v1beta, or is not supported for generateContent. Call ListModels to see the list of available models and their supported methods.','2026-01-28 18:25:30.431323',1,NULL);
INSERT INTO "messages" VALUES(9,'user','hi','2026-01-28 18:27:35.168167',1,NULL);
INSERT INTO "messages" VALUES(10,'bot','Gemini Error: 404 models/gemini-1.5-pro is not found for API version v1beta, or is not supported for generateContent. Call ListModels to see the list of available models and their supported methods.','2026-01-28 18:27:35.168167',1,NULL);
INSERT INTO "messages" VALUES(11,'user','fdgdf','2026-01-28 18:27:41.728839',1,NULL);
INSERT INTO "messages" VALUES(12,'bot','Gemini Error: 404 models/gemini-pro is not found for API version v1beta, or is not supported for generateContent. Call ListModels to see the list of available models and their supported methods.','2026-01-28 18:27:41.728839',1,NULL);
INSERT INTO "messages" VALUES(13,'user','hi','2026-01-28 18:27:50.007620',4,NULL);
INSERT INTO "messages" VALUES(14,'bot','Gemini Error: 404 models/gemini-pro is not found for API version v1beta, or is not supported for generateContent. Call ListModels to see the list of available models and their supported methods.','2026-01-28 18:27:50.007620',4,NULL);
INSERT INTO "messages" VALUES(19,'user','Hi gemini','2026-01-28 18:32:45.685017',7,NULL);
INSERT INTO "messages" VALUES(20,'bot','Hello! How can I help you today?','2026-01-28 18:32:45.685017',7,NULL);
INSERT INTO "messages" VALUES(21,'user','generate a formcontroller using Kony Api','2026-01-28 18:33:50.360880',8,NULL);
INSERT INTO "messages" VALUES(22,'bot','When working with Kony (now HCLSoftware''s HCL Volt MX), a "formcontroller" is a JavaScript file that manages the lifecycle, data, and user interactions of a specific form (screen) in your application.

Since Kony/Volt MX primarily uses JavaScript for controller logic, "strict typing" is best achieved through **JSDoc annotations**. This allows modern IDEs (like VS Code) to provide type checking and auto-completion, enhancing code robustness.

Regarding "Modern Clean CSS," it''s important to note that **Kony/Volt MX forms and widgets are styled using a built-in skinning and theme system within Kony Visualizer, not directly with vanilla CSS files managed by the developer in the controller.** You apply pre-defined skins (which internally resolve to CSS properties) to widgets through the Visualizer or programmatically. Therefore, the CSS rule doesn''t directly apply to the controller''s JavaScript code itself, but I will clarify how styling is handled in Volt MX.

---

### Kony Form Controller Example: `frmProductListController.js`

Let''s imagine you have a form named `frmProductList` in Kony Visualizer, designed to display a list of products using a `SegmentedUI` widget, along with a button to add new products and a loading indicator.

**Assumptions for this example:**

*   **Form ID:** `frmProductList`
*   **Widgets on `frmProductList`:**
    *   `segProducts` (SegmentedUI)
    *   `btnAddProduct` (Button)
    *   `flxLoading` (FlexContainer - to act as a custom loading indicator)
*   **Segment Row Template:** You have a FlexContainer designed as a row template for `segProducts`, let''s call its ID `flxProductRowTemplate`. Within this template, there are widgets like `imgProduct`, `lblProductName`, `lblProductPrice`.

```javascript
// File: forms/frmProductList/frmProductListController.js

/**
 * @namespace forms.frmProductList
 */

/**
 * @typedef {object} Product
 * @property {string} id - Unique identifier for the product.
 * @property {string} name - Name of the product.
 * @property {string} description - Detailed description of the product.
 * @property {number} price - Price of the product.
 * @property {string} imageUrl - Resource name or URL for the product image.
 */

/**
 * @typedef {object} FormView - Type definition for the widgets available on frmProductList.
 * @property {kony.ui.Form} frmProductList - The Kony Form widget itself.
 * @property {kony.ui.SegmentedUI} segProducts - Segment widget to display products.
 * @property {kony.ui.Button} btnAddProduct - Button to add a new product.
 * @property {kony.ui.Label} lblHeader - Header label (example).
 * @property {kony.ui.FlexContainer} flxLoading - A custom FlexContainer used as a loading indicator.
 *
 * // Widgets expected within the ''flxProductRowTemplate'' for segProducts:
 * @property {kony.ui.FlexContainer} flxProductRowTemplate - The template container for each segment row.
 * @property {kony.ui.Image} imgProduct - Image widget inside the row template.
 * @property {kony.ui.Label} lblProductName - Label for product name inside the row template.
 * @property {kony.ui.Label} lblProductPrice - Label for product price inside the row template.
 */

/**
 * @typedef {object} KonyFormControllerContext - The ''this'' context provided to Kony form controller methods.
 * @property {FormView} view - Reference to the form''s widgets, automatically bound by Kony.
 * @property {kony.mvc.Navigation} navigation - Kony''s navigation utility (often available via `this.navigation` or `new kony.mvc.Navigation()`).
 * @property {object} applicationManager - (Optional) Reference to your application''s global manager.
 * @property {kony.appfoundation.Module} module - Reference to the module this controller belongs to.
 */

/**
 * Controller for the `frmProductList` form.
 * This object defines the lifecycle methods and event handlers for listing and managing products.
 *
 * @type {KonyFormControllerContext & {
 *   init: (view: kony.ui.Form) => void,
 *   preShow: () => void,
 *   postShow: () => void,
 *   onDeviceBack: () => boolean,
 *   loadProducts: () => void,
 *   getMockProducts: () => Product[],
 *   onProductRowClick: (segmentWidget: kony.ui.SegmentedUI, sectionIndex: number, rowIndex: number) => void,
 *   onAddProductClick: (widget: kony.ui.Button) => void,
 *   showLoading: (show: boolean) => void
 * }}
 */
const frmProductListController = {

    /**
     * Reference to the form''s widgets, automatically bound by Kony.
     * @type {FormView}
     */
    view: null, // Kony will populate this during controller instantiation.

    /**
     * Initializes the controller and form widgets.
     * This method is called once when the form is created.
     * Use it for one-time setup, e.g., setting segment templates, registering listeners.
     *
     * @param {kony.ui.Form} view - The form instance itself (e.g., frmProductList).
     * @returns {void}
     */
    init: function(view) {
        // Assign the view for consistent access throughout the controller methods.
        // Kony automatically binds widgets to `this.view` in modern Quantum,
        // but explicitly assigning the ''view'' parameter makes JSDoc typing more robust.
        this.view = view;

        // Register event listeners for UI interactions
        // Kony typically binds the ''this'' context correctly for these callbacks.
        this.view.segProducts.onRowClick = this.onProductRowClick;
        this.view.btnAddProduct.onClick = this.onAddProductClick;

        kony.print("frmProductListController: Initialized.");
    },

    /**
     * Called before the form is displayed.
     * Use this for loading data, refreshing UI, and any setup that needs to happen
     * every time the form becomes visible.
     *
     * @returns {void}
     */
    preShow: function() {
        this.view.flxLoading.setVisibility(false); // Ensure loading indicator is hidden initially
        this.loadProducts(); // Load data every time the form is shown
        kony.print("frmProductListController: preShow.");
    },

    /**
     * Called after the form has been displayed.
     * Use this for post-render logic, e.g., animations, setting initial focus.
     *
     * @returns {void}
     */
    postShow: function() {
        kony.print("frmProductListController: postShow.");
    },

    /**
     * Called when the device''s back button is pressed (relevant for native platforms).
     *
     * @returns {boolean} True if the back navigation was handled by the controller,
     *                    false otherwise (to allow default system back behavior).
     */
    onDeviceBack: function() {
        kony.print("frmProductListController: Device back button pressed.");
        // Example: Navigate back to a dashboard form
        // If you have a navigation module:
        // this.navigation.navigate("frmDashboard");
        // Or using direct Kony API:
        // (new kony.mvc.Navigation("frmDashboard")).navigate();
        alert("Navigating back to Dashboard..."); // Placeholder for actual navigation
        return true; // Indicate that we''ve handled the back action
    },

    /**
     * Simulates fetching product data from a service (e.g., an integration service call).
     * Updates the `segProducts` SegmentedUI with the fetched data.
     *
     * @returns {void}
     */
    loadProducts: function() {
        this.showLoading(true); // Show custom loading indicator
        this.view.segProducts.setData([]); // Clear previous segment data

        // Simulate an asynchronous service call using kony.timer
        kony.timer.schedule("loadProductsTimer", () => {
            const mockProducts = this.getMockProducts();
            // Map the raw product data to the format expected by the SegmentedUI''s data map
            const segData = mockProducts.map(product => ({
                id: product.id,
                lblProductName: product.name,
                lblProductPrice: `$${product.price.toFixed(2)}`,
                imgProduct: product.imageUrl, // Map to image widget in the row template
                template: ''flxProductRowTemplate'' // The ID of your row template FlexContainer
            }));
            this.view.segProducts.setData(segData);
            this.showLoading(false); // Hide custom loading indicator
        }, 1, false); // Schedule to run once after 1 second
    },

    /**
     * Generates mock product data for demonstration purposes.
     * In a real application, this would come from a backend service.
     *
     * @private
     * @returns {Product[]} An array of mock product objects.
     */
    getMockProducts: function() {
        /** @type {Product[]} */
        const products = [
            { id: "P001", name: "Wireless Headphones", description: "High-fidelity sound, noise-cancelling.", price: 199.99, imageUrl: "icon_headphones.png" },
            { id: "P002", name: "Smartwatch", description: "Fitness tracking, notifications, long battery life.", price: 249.00, imageUrl: "icon_smartwatch.png" },
            { id: "P003", name: "Portable Bluetooth Speaker", description: "Waterproof, rich bass, 10-hour playtime.", price: 79.50, imageUrl: "icon_speaker.png" },
            { id: "P004", name: "External SSD 1TB", description: "Fast data transfer, compact design.", price: 120.00, imageUrl: "icon_ssd.png" }
        ];
        return products;
    },

    /**
     * Event handler for when a product row in the `segProducts` segment is clicked.
     *
     * @param {kony.ui.SegmentedUI} segmentWidget - The segment widget that triggered the event (`this.view.segProducts`).
     * @param {number} sectionIndex - The index of the section clicked.
     * @param {number} rowIndex - The index of the row clicked within the section.
     * @returns {void}
     */
    onProductRowClick: function(segmentWidget, sectionIndex, rowIndex) {
        const selectedItem = segmentWidget.data[rowIndex];
        kony.print(`Product selected: ${selectedItem.lblProductName} (ID: ${selectedItem.id})`);

        // Example Navigation: Navigate to a product detail form, passing product ID as parameters
        const navigationParams = { productId: selectedItem.id, productName: selectedItem.lblProductName };
        // (new kony.mvc.Navigation("frmProductDetail")).navigate(navigationParams);
        alert(`Navigating to Product Detail for: ${selectedItem.lblProductName}`);
    },

    /**
     * Event handler for the "Add Product" button click.
     *
     * @param {kony.ui.Button} widget - The button widget that triggered the event (`this.view.btnAddProduct`).
     * @returns {void}
     */
    onAddProductClick: function(widget) {
        kony.print("Add Product button clicked.");
        // Example Navigation: Navigate to a form for adding a new product
        // (new kony.mvc.Navigation("frmAddProduct")).navigate();
        alert("Navigating to Add Product form.");
    },

    /**
     * Shows or hides a custom loading indicator (flxLoading FlexContainer).
     * For a global, full-screen loading indicator, use `kony.application.showLoadingScreen`.
     *
     * @param {boolean} show - True to show the loading indicator, false to hide it.
     * @returns {void}
     */
    showLoading: function(show) {
        if (this.view && this.view.flxLoading) {
            this.view.flxLoading.setVisibility(show);
        } else {
            kony.print("Warning: flxLoading widget not found on this form view. Using global loading screen fallback.");
            // Fallback to Kony''s built-in global loading screen if custom one isn''t available
            if (show) {
                kony.application.showLoadingScreen(null, "Loading...", constants.LOADING_SCREEN_IMAGE_POSITION_ONLY_LABEL, true, true, null);
            } else {
                kony.application.dismissLoadingScreen();
            }
        }
    }
};
```

---

### Explanation and Adherence to Rules:

1.  **Strict Typing (JSDoc):**
    *   **Type Definitions (`@typedef`):** We define custom types like `Product`, `FormView`, and `KonyFormControllerContext` using `@typedef`. This structures the data and the expected `this` context for better clarity and IDE support.
    *   **Property Types (`@property`):** Properties within `FormView` are explicitly typed (e.g., `{kony.ui.SegmentedUI} segProducts`).
    *   **Parameter and Return Types (`@param`, `@returns`):** Every function''s parameters and return values are annotated with their types.
    *   **`@type` for Objects:** The entire `frmProductListController` object is strictly typed using `@type` to ensure all its methods and properties conform to the expected signatures.
    *   **Kony Globals:** Standard Kony API objects like `kony.ui.Form`, `kony.ui.SegmentedUI`, `constants`, `kony.timer`, `kony.print`, etc., are assumed to be available globally in the Kony execution environment.

2.  **Modern Clean JavaScript:**
    *   **Object Literal as Controller:** This is the most common pattern for Kony/Volt MX controllers, representing a module that exports its functionality.
    *   **Arrow Functions (Implicit):** While not heavily used for top-level controller methods (as `this` binding is managed by Kony), `kony.timer.schedule` uses an arrow function for the callback, demonstrating modern JS.
    *   **`const` and `let`:** Used for variable declarations instead of `var`.
    *   **Clear Method Naming:** Methods are named descriptively (e.g., `onProductRowClick`, `loadProducts`).
    *   **Separation of Concerns:** The controller focuses on UI logic, data presentation, and navigation. Data fetching is abstracted (via `getMockProducts`) to indicate where service calls would go.

3.  **Modern Clean CSS (Volt MX Context):**
    *   As explained, you don''t write vanilla CSS directly within a Kony/Volt MX form controller.
    *   **Skinning System:** Styling is managed through **Skins** in Kony Visualizer. You would create skins (e.g., `sknFlxLoadingIndicator` for `flxLoading`, `sknSegRowDefault` for `segProducts` rows, `sknLblProductName` for text labels) that define properties like `backgroundColor`, `fontSize`, `fontColor`, `padding`, `margin`, `border`, etc. These skins are then applied to widgets.
    *   **Themes:** Skins are organized into **Themes**, allowing you to change the entire application''s look and feel by switching themes.
    *   **FlexLayout:** Kony''s UI uses FlexLayout for responsive and adaptive designs, aligning with modern web layout principles.
    *   The controller interacts with these visual properties programmatically by changing skins or visibility (e.g., `this.view.flxLoading.setVisibility(true)`), not by injecting CSS.

This `frmProductListController` provides a robust, type-annotated, and idiomatic example for developing Kony/Volt MX applications.','2026-01-28 18:33:50.360880',8,NULL);
INSERT INTO "messages" VALUES(25,'user','generate ui for kony visuvalizer','2026-01-28 18:39:54.351778',9,NULL);
INSERT INTO "messages" VALUES(26,'bot','Here''s a UI generation for a Kony Visualizer, adhering to strict typing and modern clean vanilla CSS.

This design features a common layout for visual development tools: a header, a component palette, a main canvas area, a properties panel, and a footer for status/logs.

---

### 1. TypeScript Definitions (Strict Typing)

These interfaces define the structure of data that would power such a visualizer.

```typescript
// src/types/ui.d.ts

/**
 * Represents a basic UI component type available in the palette.
 */
export interface IComponentPaletteItem {
  id: string; // Unique identifier for the component type (e.g., ''button'', ''text-input'')
  name: string; // Display name for the component (e.g., ''Button'', ''Text Input'')
  iconClass: string; // CSS class for an icon (e.g., ''icon-button'', ''icon-text-input'')
  category: string; // Category for grouping (e.g., ''Basic'', ''Layout'', ''Advanced'')
  defaultProperties: IComponentProperty[]; // Initial properties when dragged onto canvas
}

/**
 * Defines a property for a UI component.
 */
export interface IComponentProperty {
  name: string; // The property name (e.g., ''text'', ''backgroundColor'', ''width'')
  label: string; // Display label for the property in the properties panel
  type: ''text'' | ''number'' | ''color'' | ''boolean'' | ''select'' | ''textarea''; // Input type for the property editor
  value: string | number | boolean; // Current value of the property
  options?: string[]; // For ''select'' type, provides available options
  group?: string; // Optional: Group properties in the UI (e.g., ''Style'', ''Layout'', ''Data'')
}

/**
 * Represents an instance of a component placed on the canvas.
 */
export interface IVisualComponentInstance {
  instanceId: string; // Unique identifier for this specific instance on the canvas
  componentTypeId: string; // References IComponentPaletteItem.id
  position: {
    x: number; // X coordinate on the canvas (e.g., in px)
    y: number; // Y coordinate on the canvas (e.g., in px)
  };
  size: {
    width: number; // Width of the component (e.g., in px)
    height: number; // Height of the component (e.g., in px)
  };
  properties: IComponentProperty[]; // Override or extend default properties
  children?: IVisualComponentInstance[]; // For container components
  isSelected: boolean; // True if this component is currently selected in the UI
}

/**
 * Represents the overall state of the Kony Visualizer project.
 */
export interface IProjectState {
  projectName: string;
  currentPageId: string; // Identifier for the currently active page/screen
  components: IVisualComponentInstance[]; // All components currently on the canvas for the active page
  selectedComponentInstanceId: string | null; // ID of the currently selected component, or null if none
  paletteItems: IComponentPaletteItem[]; // All available component types
  appTheme: {
    primaryColor: string;
    secondaryColor: string;
    fontFamily: string;
  };
  statusMessage: string; // For displaying messages in the footer
}

/**
 * Event data for when a component is dropped onto the canvas.
 */
export interface IDropEventData {
  componentTypeId: string;
  canvasX: number;
  canvasY: number;
}

/**
 * Event data for property changes.
 */
export interface IPropertyChangeEvent {
  instanceId: string;
  propertyName: string;
  newValue: string | number | boolean;
}
```

---

### 2. HTML Structure

This HTML provides the basic layout using semantic elements.

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kony Visualizer</title>
    <link rel="stylesheet" href="style.css">
    <!-- Example for icons. In a real app, you''d use a robust icon library or custom SVGs. -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div id="app-container">
        <!-- Header -->
        <header class="app-header">
            <div class="header-left">
                <h1 class="app-title">Kony Visualizer</h1>
                <span class="project-name">Project: My Mobile App</span>
            </div>
            <nav class="header-nav">
                <button class="nav-button"><i class="fas fa-save"></i> Save</button>
                <button class="nav-button"><i class="fas fa-play"></i> Preview</button>
                <button class="nav-button"><i class="fas fa-file-export"></i> Export</button>
            </nav>
            <div class="header-right">
                <button class="nav-button settings"><i class="fas fa-cog"></i></button>
                <button class="nav-button help"><i class="fas fa-question-circle"></i></button>
            </div>
        </header>

        <!-- Main Content Area -->
        <div class="main-content-grid">
            <!-- Component Palette (Left Sidebar) -->
            <aside class="component-palette">
                <div class="palette-header">
                    <h2>Components</h2>
                    <input type="search" placeholder="Search components..." class="search-input">
                </div>
                <div class="palette-categories">
                    <div class="palette-category">
                        <h3>Basic Widgets</h3>
                        <div class="component-list">
                            <div class="component-item" draggable="true" data-component-type="button">
                                <i class="fas fa-square-full"></i> <span>Button</span>
                            </div>
                            <div class="component-item" draggable="true" data-component-type="label">
                                <i class="fas fa-font"></i> <span>Label</span>
                            </div>
                            <div class="component-item" draggable="true" data-component-type="text-input">
                                <i class="fas fa-edit"></i> <span>Text Input</span>
                            </div>
                            <div class="component-item" draggable="true" data-component-type="image">
                                <i class="fas fa-image"></i> <span>Image</span>
                            </div>
                            <div class="component-item" draggable="true" data-component-type="checkbox">
                                <i class="fas fa-check-square"></i> <span>Checkbox</span>
                            </div>
                        </div>
                    </div>
                    <div class="palette-category">
                        <h3>Layout Containers</h3>
                        <div class="component-list">
                            <div class="component-item" draggable="true" data-component-type="flex-container">
                                <i class="fas fa-columns"></i> <span>Flex Container</span>
                            </div>
                            <div class="component-item" draggable="true" data-component-type="segment">
                                <i class="fas fa-list"></i> <span>Segment</span>
                            </div>
                        </div>
                    </div>
                    <!-- More categories -->
                </div>
            </aside>

            <!-- Canvas Area (Center) -->
            <main class="canvas-container">
                <div class="canvas-toolbar">
                    <span class="device-selector">
                        <i class="fas fa-mobile-alt"></i> Phone <i class="fas fa-chevron-down"></i>
                    </span>
                    <button class="toolbar-button"><i class="fas fa-undo"></i></button>
                    <button class="toolbar-button"><i class="fas fa-redo"></i></button>
                    <button class="toolbar-button"><i class="fas fa-ruler-combined"></i></button>
                    <span class="zoom-level">100%</span>
                </div>
                <div id="visualizer-canvas" class="visualizer-canvas drop-target">
                    <!-- Example components placed on canvas (these would be dynamically added by TS) -->
                    <div class="canvas-component canvas-component--button selected"
                         style="left: 50px; top: 50px; width: 120px; height: 40px;"
                         data-instance-id="btn1">
                        Button 1
                        <div class="resizer top-left"></div>
                        <div class="resizer top-right"></div>
                        <div class="resizer bottom-left"></div>
                        <div class="resizer bottom-right"></div>
                    </div>
                    <div class="canvas-component canvas-component--label"
                         style="left: 200px; top: 100px; width: 150px; height: 30px;"
                         data-instance-id="lbl1">
                        Hello World Label
                        <div class="resizer top-left"></div>
                        <div class="resizer top-right"></div>
                        <div class="resizer bottom-left"></div>
                        <div class="resizer bottom-right"></div>
                    </div>
                </div>
            </main>

            <!-- Properties Panel (Right Sidebar) -->
            <aside class="properties-panel">
                <div class="panel-header">
                    <h2>Properties <span class="selected-component-name">(Button 1)</span></h2>
                </div>
                <div class="properties-list">
                    <div class="property-group">
                        <h3>General</h3>
                        <div class="property-item">
                            <label for="prop-id">ID</label>
                            <input type="text" id="prop-id" value="button123" readonly>
                        </div>
                        <div class="property-item">
                            <label for="prop-text">Text</label>
                            <input type="text" id="prop-text" value="Click Me">
                        </div>
                    </div>
                    <div class="property-group">
                        <h3>Style</h3>
                        <div class="property-item">
                            <label for="prop-bg-color">Background Color</label>
                            <input type="color" id="prop-bg-color" value="#007bff">
                        </div>
                        <div class="property-item">
                            <label for="prop-text-color">Text Color</label>
                            <input type="color" id="prop-text-color" value="#ffffff">
                        </div>
                        <div class="property-item">
                            <label for="prop-font-size">Font Size (px)</label>
                            <input type="number" id="prop-font-size" value="16">
                        </div>
                        <div class="property-item">
                            <label for="prop-border-radius">Border Radius (px)</label>
                            <input type="number" id="prop-border-radius" value="4">
                        </div>
                    </div>
                    <div class="property-group">
                        <h3>Layout</h3>
                        <div class="property-item">
                            <label for="prop-x">X</label>
                            <input type="number" id="prop-x" value="50">
                        </div>
                        <div class="property-item">
                            <label for="prop-y">Y</label>
                            <input type="number" id="prop-y" value="50">
                        </div>
                        <div class="property-item">
                            <label for="prop-width">Width</label>
                            <input type="number" id="prop-width" value="120">
                        </div>
                        <div class="property-item">
                            <label for="prop-height">Height</label>
                            <input type="number" id="prop-height" value="40">
                        </div>
                    </div>
                    <!-- More property groups (e.g., Data, Events) -->
                </div>
            </aside>
        </div>

        <!-- Footer -->
        <footer class="app-footer">
            <div class="status-message">
                <i class="fas fa-info-circle"></i> Project saved successfully.
            </div>
            <div class="version-info">
                Kony Visualizer v1.0.0
            </div>
        </footer>
    </div>
</body>
</html>
```

---

### 3. Modern Clean CSS (Vanilla CSS)

This CSS uses modern features like CSS variables, Flexbox, and Grid for layout, ensuring a clean and responsive base.

```css
/* style.css */

/* CSS Variables for consistent theming */
:root {
    --primary-color: #007bff;
    --primary-color-dark: #0056b3;
    --secondary-color: #6c757d;
    --background-color: #f8f9fa;
    --surface-color: #ffffff;
    --border-color: #dee2e6;
    --text-color: #343a40;
    --text-light-color: #6c757d;
    --header-height: 60px;
    --footer-height: 40px;
    --sidebar-width: 250px;
    --spacing-xs: 4px;
    --spacing-sm: 8px;
    --spacing-md: 12px;
    --spacing-lg: 16px;
    --font-family-sans: ''Segoe UI'', Roboto, ''Helvetica Neue'', Arial, sans-serif;
    --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
    --shadow-md: 0 2px 4px rgba(0, 0, 0, 0.1);
    --hover-bg: #e9ecef;
    --selected-border: 2px solid var(--primary-color);
}

/* Base Styles and Resets */
*, *::before, *::after {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: var(--font-family-sans);
    line-height: 1.6;
    color: var(--text-color);
    background-color: var(--background-color);
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    overflow: hidden; /* Prevent body scroll, app-container handles it */
}

a {
    color: var(--primary-color);
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

button {
    background-color: transparent;
    border: none;
    cursor: pointer;
    font-family: inherit;
    font-size: inherit;
    color: inherit;
    padding: 0;
}

input[type="text"],
input[type="number"],
input[type="search"],
input[type="color"],
textarea {
    padding: var(--spacing-sm);
    border: 1px solid var(--border-color);
    border-radius: var(--spacing-xs);
    font-family: inherit;
    font-size: 0.9rem;
    color: var(--text-color);
    background-color: var(--surface-color);
    transition: border-color 0.2s ease;
}

input[type="text"]:focus,
input[type="number"]:focus,
input[type="search"]:focus,
input[type="color"]:focus,
textarea:focus {
    outline: none;
    border-color: var(--primary-color);
    box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
}

/* Layout Grid for the entire application */
#app-container {
    display: grid;
    grid-template-areas:
        "header header header"
        "palette canvas properties"
        "footer footer footer";
    grid-template-rows: var(--header-height) 1fr var(--footer-height);
    grid-template-columns: var(--sidebar-width) 1fr var(--sidebar-width);
    height: 100vh;
    overflow: hidden; /* Ensure content stays within the grid cells */
}

/* Header */
.app-header {
    grid-area: header;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 var(--spacing-lg);
    background-color: var(--surface-color);
    border-bottom: 1px solid var(--border-color);
    box-shadow: var(--shadow-sm);
    z-index: 10;
}

.app-header .header-left,
.app-header .header-right,
.app-header .header-nav {
    display: flex;
    align-items: center;
    gap: var(--spacing-md);
}

.app-title {
    font-size: 1.2rem;
    font-weight: 600;
    color: var(--primary-color-dark);
}

.project-name {
    font-size: 0.9rem;
    color: var(--text-light-color);
    margin-left: var(--spacing-md);
}

.nav-button {
    padding: var(--spacing-sm) var(--spacing-md);
    border-radius: var(--spacing-xs);
    font-size: 0.9rem;
    color: var(--text-color);
    transition: background-color 0.2s ease, color 0.2s ease;
}

.nav-button:hover {
    background-color: var(--hover-bg);
    color: var(--primary-color-dark);
}

.nav-button i {
    margin-right: var(--spacing-xs);
}

/* Main Content Grid for Sidebars and Canvas */
.main-content-grid {
    grid-area: palette / canvas / properties; /* Spans across these grid areas */
    display: contents; /* Allows child elements to be placed by the main grid */
}

/* Component Palette (Left Sidebar) */
.component-palette {
    grid-area: palette;
    background-color: var(--surface-color);
    border-right: 1px solid var(--border-color);
    display: flex;
    flex-direction: column;
    padding-bottom: var(--spacing-md); /* Add some padding at bottom */
    overflow-y: auto; /* Enable scrolling for palette items */
    scrollbar-width: thin;
    scrollbar-color: var(--border-color) transparent;
}

.palette-header {
    padding: var(--spacing-md);
    border-bottom: 1px solid var(--border-color);
    position: sticky; /* Keep header visible on scroll */
    top: 0;
    background-color: var(--surface-color);
    z-index: 5;
}

.palette-header h2 {
    font-size: 1.1rem;
    margin-bottom: var(--spacing-sm);
}

.palette-header .search-input {
    width: 100%;
    font-size: 0.85rem;
}

.palette-categories {
    flex-grow: 1;
    padding: var(--spacing-md);
}

.palette-category {
    margin-bottom: var(--spacing-lg);
}

.palette-category h3 {
    font-size: 0.95rem;
    color: var(--text-light-color);
    text-transform: uppercase;
    margin-bottom: var(--spacing-sm);
    padding-left: var(--spacing-xs);
    letter-spacing: 0.5px;
}

.component-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
    gap: var(--spacing-sm);
}

.component-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: var(--spacing-md);
    border: 1px solid var(--border-color);
    border-radius: var(--spacing-xs);
    background-color: var(--background-color);
    cursor: grab;
    user-select: none;
    transition: background-color 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
    font-size: 0.85rem;
    text-align: center;
}

.component-item:hover {
    background-color: var(--hover-bg);
    border-color: var(--primary-color);
    box-shadow: var(--shadow-sm);
}

.component-item i {
    font-size: 1.5rem;
    margin-bottom: var(--spacing-sm);
    color: var(--primary-color);
}

/* Canvas Area */
.canvas-container {
    grid-area: canvas;
    display: flex;
    flex-direction: column;
    background-color: var(--background-color);
    overflow: hidden; /* Canvas itself will be scrollable, but this container manages toolbar */
}

.canvas-toolbar {
    display: flex;
    align-items: center;
    gap: var(--spacing-md);
    padding: var(--spacing-sm) var(--spacing-lg);
    background-color: var(--surface-color);
    border-bottom: 1px solid var(--border-color);
    flex-shrink: 0; /* Prevent toolbar from shrinking */
}

.canvas-toolbar .toolbar-button {
    padding: var(--spacing-xs) var(--spacing-sm);
    border-radius: var(--spacing-xs);
    font-size: 0.85rem;
    color: var(--text-color);
}

.canvas-toolbar .toolbar-button:hover {
    background-color: var(--hover-bg);
}

.device-selector {
    display: flex;
    align-items: center;
    gap: var(--spacing-xs);
    padding: var(--spacing-xs) var(--spacing-sm);
    border-radius: var(--spacing-xs);
    background-color: var(--background-color);
    border: 1px solid var(--border-color);
    cursor: pointer;
    font-size: 0.85rem;
    color: var(--text-color);
}

.device-selector:hover {
    background-color: var(--hover-bg);
}

.zoom-level {
    margin-left: auto; /* Push to the right */
    font-size: 0.85rem;
    color: var(--text-light-color);
}

.visualizer-canvas {
    flex-grow: 1;
    position: relative;
    background-color: #e0e6ed; /* Light grey background for canvas */
    background-image:
        linear-gradient(to right, var(--border-color) 1px, transparent 1px),
        linear-gradient(to bottom, var(--border-color) 1px, transparent 1px);
    background-size: 20px 20px; /* Grid size */
    overflow: auto; /* Enable scrolling for the canvas content */
    display: flex; /* Use flex to center the "device" mock */
    justify-content: center;
    align-items: center;
    padding: var(--spacing-lg);
}

/* Mock Device Container within Canvas (optional, for responsive design views) */
.visualizer-canvas::before {
    content: '''';
    position: absolute;
    width: 375px; /* Typical phone width */
    height: 667px; /* Typical phone height */
    background-color: var(--surface-color);
    border: 1px solid var(--border-color);
    border-radius: var(--spacing-lg);
    box-shadow: var(--shadow-md);
    z-index: 1;
    pointer-events: none; /* Allows clicks to pass through to components */
}

/* Canvas Components (dynamically added) */
.canvas-component {
    position: absolute; /* Positioned relative to the canvas */
    background-color: #cccccc; /* Default background for visual components */
    border: 1px solid var(--secondary-color);
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 0.9rem;
    color: var(--text-color);
    cursor: grab;
    user-select: none;
    min-width: 20px;
    min-height: 20px;
    z-index: 2; /* Above mock device */
    transition: border-color 0.1s ease;
}

.canvas-component:hover {
    border-color: var(--primary-color);
}

.canvas-component.selected {
    border: var(--selected-border);
    box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
    z-index: 3; /* Bring selected component to front */
}

/* Resizers for selected components */
.canvas-component.selected .resizer {
    display: block;
}

.resizer {
    display: none; /* Hidden by default */
    position: absolute;
    width: 10px;
    height: 10px;
    background-color: var(--primary-color);
    border: 1px solid var(--surface-color);
    border-radius: 50%;
    z-index: 4; /* Above the component */
}

.resizer.top-left { top: -5px; left: -5px; cursor: nwse-resize; }
.resizer.top-right { top: -5px; right: -5px; cursor: nesw-resize; }
.resizer.bottom-left { bottom: -5px; left: -5px; cursor: nesw-resize; }
.resizer.bottom-right { bottom: -5px; right: -5px; cursor: nwse-resize; }


/* Specific styling for example component types */
.canvas-component--button {
    background-color: var(--primary-color);
    color: var(--surface-color);
    border-radius: var(--spacing-xs);
    font-weight: 500;
}

.canvas-component--label {
    background-color: transparent;
    color: var(--text-color);
    border: none;
    justify-content: flex-start;
    padding-left: var(--spacing-sm);
}

/* Properties Panel (Right Sidebar) */
.properties-panel {
    grid-area: properties;
    background-color: var(--surface-color);
    border-left: 1px solid var(--border-color);
    display: flex;
    flex-direction: column;
    overflow-y: auto; /* Enable scrolling for properties */
    scrollbar-width: thin;
    scrollbar-color: var(--border-color) transparent;
}

.panel-header {
    padding: var(--spacing-md);
    border-bottom: 1px solid var(--border-color);
    position: sticky;
    top: 0;
    background-color: var(--surface-color);
    z-index: 5;
}

.panel-header h2 {
    font-size: 1.1rem;
}

.panel-header .selected-component-name {
    font-size: 0.9rem;
    color: var(--text-light-color);
    margin-left: var(--spacing-sm);
}

.properties-list {
    flex-grow: 1;
    padding: var(--spacing-md);
}

.property-group {
    margin-bottom: var(--spacing-lg);
    border-bottom: 1px dashed var(--border-color);
    padding-bottom: var(--spacing-md);
}

.property-group:last-of-type {
    border-bottom: none;
    padding-bottom: 0;
}

.property-group h3 {
    font-size: 0.95rem;
    color: var(--text-color);
    margin-bottom: var(--spacing-md);
    font-weight: 600;
}

.property-item {
    display: flex;
    flex-direction: column;
    margin-bottom: var(--spacing-sm);
}

.property-item label {
    font-size: 0.85rem;
    color: var(--text-light-color);
    margin-bottom: var(--spacing-xs);
}

.property-item input[type="text"],
.property-item input[type="number"],
.property-item input[type="color"] {
    width: 100%;
}

/* Footer */
.app-footer {
    grid-area: footer;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 var(--spacing-lg);
    background-color: var(--surface-color);
    border-top: 1px solid var(--border-color);
    box-shadow: var(--shadow-sm);
    font-size: 0.8rem;
    color: var(--text-light-color);
    z-index: 10;
}

.status-message i {
    margin-right: var(--spacing-xs);
    color: var(--primary-color);
}
```','2026-01-28 18:39:54.351778',9,NULL);
INSERT INTO "messages" VALUES(27,'user','Hi Hello','2026-01-28 19:15:06.562179',10,NULL);
INSERT INTO "messages" VALUES(28,'bot','Hello!

I''m ready to help. I will ensure any code generation strictly adheres to type definitions and use modern, clean vanilla CSS for styling.

How can I assist you today?','2026-01-28 19:15:06.562179',10,NULL);
INSERT INTO "messages" VALUES(29,'user','fghgfh','2026-01-28 19:15:18.645242',11,NULL);
INSERT INTO "messages" VALUES(30,'bot','The input "fghgfh" is not a valid request or question. Please provide a clear and actionable prompt so I can assist you.

When providing a prompt, please keep in mind:
*   I will use **Strict Typing** for any code generation (e.g., TypeScript for JavaScript, explicit types for Python).
*   For styling, I will prefer **Modern Clean Vanilla CSS** utilizing features like custom properties, flexbox, grid, and logical properties, rather than CSS libraries or frameworks, unless specifically requested.','2026-01-28 19:15:18.645242',11,NULL);
INSERT INTO "messages" VALUES(31,'user','hi my friend raja rajan','2026-01-28 19:19:38.948466',11,NULL);
INSERT INTO "messages" VALUES(32,'bot','Hello there! It''s good to meet you, Raja Rajan.

How can I assist you today? Please let me know if you have a specific task in mind, perhaps involving code generation with strict typing, or modern clean CSS. I''m ready when you are!','2026-01-28 19:19:38.948976',11,NULL);
INSERT INTO "messages" VALUES(33,'user','does gluteus medius will cause L4 L5 Bulge','2026-01-28 19:21:42.654181',11,NULL);
INSERT INTO "messages" VALUES(34,'bot','I cannot provide medical advice or diagnose conditions. Questions about the causes or implications of an L4-L5 disc bulge, or the role of specific muscles like the gluteus medius, require the expertise of a qualified healthcare professional.

**Please consult with a doctor, physical therapist, or other medical specialist for an accurate diagnosis and appropriate treatment plan.** They will be able to assess your individual situation and provide reliable information.

While I understand you''ve provided rules regarding strict typing and modern CSS, those are for tasks involving code generation or styling, which is not applicable to a medical query. My purpose is to assist with programming and design-related tasks, not healthcare.','2026-01-28 19:21:42.654181',11,NULL);
INSERT INTO "messages" VALUES(35,'user','HI','2026-01-28 21:45:36.196450',12,NULL);
INSERT INTO "messages" VALUES(36,'bot','Hello! How can I help you today?','2026-01-28 21:45:36.196450',12,NULL);
INSERT INTO "messages" VALUES(37,'user','hello','2026-01-30 08:40:29.479972',12,NULL);
INSERT INTO "messages" VALUES(38,'bot','Hello there! How can I help you today?','2026-01-30 08:40:29.479972',12,NULL);
INSERT INTO "messages" VALUES(39,'user','hii','2026-01-30 08:51:11.634524',13,NULL);
INSERT INTO "messages" VALUES(40,'bot','Hello there! How can I help you today?','2026-01-30 08:51:11.634524',13,NULL);
INSERT INTO "messages" VALUES(41,'user','hello','2026-01-30 09:03:15.174453',14,NULL);
INSERT INTO "messages" VALUES(42,'bot','Hello! How can I help you today?','2026-01-30 09:03:15.174453',14,NULL);
INSERT INTO "messages" VALUES(43,'user','who is delulu ','2026-01-30 10:43:02.712925',15,NULL);
INSERT INTO "messages" VALUES(44,'bot','"Delulu" is internet slang, short for "delusional."

Someone is described as "delulu" if they hold unrealistic, overly optimistic, or fantastical beliefs, often about:

*   **A romantic relationship (real or imagined):** For example, believing a celebrity is secretly in love with them, or that a casual acquaintance is their soulmate despite no reciprocal signs.
*   **Their own potential or abilities:** Having wildly impractical career goals without any basis, or believing they are destined for something without any effort.
*   **General situations:** Being overly optimistic about an outcome despite clear evidence to the contrary.

It''s often used humorously or self-deprecatingly, but it can also be used as a criticism. It''s not a clinical term, but rather a colloquial way to describe someone whose hopes or beliefs are significantly disconnected from reality.','2026-01-30 10:43:02.712925',15,NULL);
INSERT INTO "messages" VALUES(45,'user','what is the problem in janayagan movie release','2026-01-30 10:43:35.735848',16,NULL);
INSERT INTO "messages" VALUES(46,'bot','The movie **Janayagan** is a Tamil film that was released way back in **1993**, starring Sathyaraj.

There are no widely known or reported "problems" with its original release. It was released in theaters and was a notable film of its time.

Perhaps you are thinking of a different, more recent film, or a re-release issue? If you have more context or are thinking of another movie, please let me know!','2026-01-30 10:43:35.735848',16,NULL);
INSERT INTO "messages" VALUES(47,'user','no janayagan is a thalapathi movie','2026-01-30 10:44:36.218033',17,NULL);
INSERT INTO "messages" VALUES(48,'bot','Okay, I understand. You''re stating that "Janayagan" (meaning ''Leader of the People'') refers to a movie starring actor Vijay, who is popularly known as "Thalapathi."','2026-01-30 10:44:36.218033',17,NULL);
INSERT INTO "messages" VALUES(49,'user','today current news','2026-01-30 10:45:02.393452',18,NULL);
INSERT INTO "messages" VALUES(50,'bot','As of **May 28, 2024**, here''s a brief overview of some current global news highlights:

*   **Gaza Conflict:** International pressure continues to mount for a ceasefire and humanitarian aid. Diplomatic efforts are ongoing, and the humanitarian situation remains dire following recent Israeli operations in Rafah.
*   **Ukraine War:** Fighting continues in eastern Ukraine, particularly around Kharkiv and Donetsk. Ukraine is pressing for more advanced Western weaponry and aid, while Russia continues its offensive operations.
*   **Economic Outlook:** Global markets are closely watching inflation data and central bank decisions regarding interest rates. Energy prices are fluctuating amidst geopolitical tensions and supply considerations.
*   **Political Developments:**
    *   **US Politics:** Focus remains on the upcoming presidential election and various legislative debates.
    *   **European Union:** Preparations for the European Parliament elections (June 6-9) are underway, with debates on key policies and future leadership.
*   **Global Climate:** Discussions continue on climate change impacts and sustainable development, with ongoing reports of extreme weather events in various regions.

For the very latest and most detailed information, please refer to reputable news sources.','2026-01-30 10:45:02.393452',18,NULL);
INSERT INTO "messages" VALUES(51,'user','hello','2026-01-30 10:45:21.730237',19,NULL);
INSERT INTO "messages" VALUES(52,'bot','OpenAI Error: Error code: 401 - {''error'': {''message'': ''Incorrect API key provided: your_ope************here. You can find your API key at https://platform.openai.com/account/api-keys.'', ''type'': ''invalid_request_error'', ''param'': None, ''code'': ''invalid_api_key''}}','2026-01-30 10:45:21.730237',19,NULL);
INSERT INTO "messages" VALUES(53,'user','Hi ','2026-01-30 11:46:04.813504',20,NULL);
INSERT INTO "messages" VALUES(54,'bot','Please provide the rules you''d like me to follow! I''m ready once you share them.','2026-01-30 11:46:04.813504',20,NULL);
INSERT INTO "messages" VALUES(55,'user','sdhfsd','2026-01-30 11:46:33.350962',21,NULL);
INSERT INTO "messages" VALUES(56,'bot','Please provide the rules you would like me to follow.','2026-01-30 11:46:33.350962',21,NULL);
INSERT INTO "messages" VALUES(57,'user','I don''t have rule','2026-01-30 11:47:01.493378',22,NULL);
INSERT INTO "messages" VALUES(58,'bot','I understand your statement. As an AI, I operate within a set of guidelines and principles that help me provide information and complete tasks safely and helpfully.','2026-01-30 11:47:01.493378',22,NULL);
INSERT INTO "messages" VALUES(59,'user','my name ashwath','2026-01-30 11:48:05.956303',22,NULL);
INSERT INTO "messages" VALUES(60,'bot','Hello Ashwath, it''s nice to meet you!','2026-01-30 11:48:05.956303',22,NULL);
INSERT INTO "messages" VALUES(61,'user','who is actor vijay','2026-01-30 11:48:30.440239',22,NULL);
INSERT INTO "messages" VALUES(62,'bot','Hello Ashwath!

Actor Vijay, whose full name is Joseph Vijay Chandrasekhar, is a very prominent and popular Indian actor, playback singer, and producer. He primarily works in Tamil cinema, often referred to as Kollywood.

He is one of the highest-paid actors in India and has an enormous fanbase, especially in Tamil Nadu and among the Tamil diaspora worldwide. He is known for his dynamic screen presence, action sequences, dance moves, and ability to portray a variety of roles. Fans often refer to him by the honorific "Thalapathy" (Commander).

Some of his most well-known films include:
*   **Ghilli**
*   **Thuppakki**
*   **Kaththi**
*   **Mersal**
*   **Sarkar**
*   **Master**
*   **Leo**

He has had a highly successful career spanning several decades, starting as a child artist and rising to superstardom.','2026-01-30 11:48:30.440239',22,NULL);
INSERT INTO "messages" VALUES(63,'user','`DFGFD','2026-01-30 12:24:27.079105',23,NULL);
INSERT INTO "messages" VALUES(64,'bot','I cannot follow rules if no rules are provided. Please provide the rules.','2026-01-30 12:24:27.079105',23,NULL);
INSERT INTO "messages" VALUES(65,'user','hi','2026-01-30 12:27:11.131081',24,NULL);
INSERT INTO "messages" VALUES(66,'bot','Gemini Error: Invalid operation: The `response.text` quick accessor requires the response to contain a valid `Part`, but none were returned. The candidate''s [finish_reason](https://ai.google.dev/api/generate-content#finishreason) is 1.','2026-01-30 12:27:11.131081',24,NULL);
INSERT INTO "messages" VALUES(67,'user','hnj','2026-01-30 12:27:27.655699',25,NULL);
INSERT INTO "messages" VALUES(68,'bot','I''m ready to follow the rules, but you haven''t provided any yet!','2026-01-30 12:27:27.655699',25,NULL);
INSERT INTO "messages" VALUES(69,'user','hi','2026-01-30 12:33:35.318708',26,NULL);
INSERT INTO "messages" VALUES(70,'bot','Hi there! How can I help you today?','2026-01-30 12:33:35.318708',26,NULL);
INSERT INTO "messages" VALUES(71,'user','generate a ui and controller','2026-01-30 12:56:03.802845',27,NULL);
INSERT INTO "messages" VALUES(72,'bot','Okay, I will generate a Kony Visualizer UI (conceptual .sm and its controller) and the corresponding Presentation and Business Controllers, strictly following all the provided guidelines, naming conventions, and sample structures, especially for the MVC lifecycle, service calls, and accessibility.

---

### **1. UI - Form Definition (`frmUserDetailsKA.sm`)**

*(Note: As an AI, I cannot generate the actual `.sm` file. Below is a conceptual representation of the form''s structure and widgets as it would be defined in Kony Visualizer. The associated controller will reference these widgets.)*

```xml
<!-- frmUserDetailsKA.sm (Conceptual Kony Visualizer Form XML) -->
<Form id="frmUserDetailsKA" skin="slForm" device="mobile" onNavigate="frmUserDetailsKA_onNavigate" name="frmUserDetailsKA" init="frmUserDetailsKA_init">
    <FlexContainer id="flxMainContentKA" skin="sknFlxWhiteRoundedKA" layoutType="VBOX">
        <Label id="lblTitleKA" skin="sknLblHeaderKA" text="User Details Form"/>
        <Image id="imgUserKA" src="user_icon.png" skin="sknImgUserKA"/>
        <Label id="lblUserNameKA" skin="sknLblNormalKA" text="Username:"/>
        <TextBox id="tbxUserNameKA" skin="sknTbxNormalKA" placeholder="Enter username"/>
        <Button id="btnSubmitKA" skin="sknBtnPrimaryKA" text="Submit Details" onClick="btnSubmitKA_onClick"/>
    </FlexContainer>
</Form>

<!-- Conceptual Skins (e.g., in skins/default/sknLblHeaderKA.json) -->
<!-- sknLblHeaderKA: fontColor: #333333, fontSize: 18pt, fontWeight: bold, textAlignment: center -->
<!-- sknImgUserKA: contentAlignment: center, backgroundColor: transparent -->
<!-- sknLblNormalKA: fontColor: #666666, fontSize: 12pt, fontWeight: normal -->
<!-- sknTbxNormalKA: borderColor: #CCCCCC, borderWidth: 1px, cornerRadius: 5px, padding: [5,5,5,5] -->
<!-- sknBtnPrimaryKA: backgroundColor: #007AFF, fontColor: #FFFFFF, cornerRadius: 5px -->
<!-- sknFlxWhiteRoundedKA: backgroundColor: #FFFFFF, cornerRadius: 10px, padding: [10,10,10,10], margin: [10,10,10,10] -->
<!-- slForm: default form skin -->
```

---

### **2. Form Controller (`modules/FormControllers/mobile/frmUserDetailsKAController.js`)**

```javascript
define(["accessibility"], function (accessibility) {
    /**
     * @module frmUserDetailsKAController
     * @description Controller for the frmUserDetailsKA form.
     * Handles UI lifecycle, events, and interacts with the Presentation layer.
     */
    return {

        /**
         * @function onNavigate
         * @description Form''s onNavigate event handler. Sets preShow and postShow callbacks.
         */
        onNavigate: function () {
            kony.print("frmUserDetailsKAController: onNavigate called.");
            this.view.preShow = this.preShow;
            this.view.postShow = this.postShow;
            // No widget manipulation or service calls here.
        },

        /**
         * @function init
         * @description Form''s init event handler. Called once when the form is initialized.
         * Sets default values and calls preShow.
         */
        init: function () {
            kony.print("frmUserDetailsKAController: init called. Setting default values and calling preShow.");
            // Set default values or states
            this.view.lblTitleKA.text = kony.i18n.getLocalizedString("i18n.user_details.form.title");
            this.view.lblUserNameKA.text = kony.i18n.getLocalizedString("i18n.user_details.form.usernameLabel");
            this.view.tbxUserNameKA.placeholder = kony.i18n.getLocalizedString("i18n.user_details.form.usernamePlaceholder");
            this.view.btnSubmitKA.text = kony.i18n.getLocalizedString("i18n.user_details.form.submitButton");

            // Ensure preShow is called as part of the lifecycle
            this.preShow();
        },

        /**
         * @function preShow
         * @description Form''s preShow event handler. Called before the form is displayed.
         * Used for UI setup that should happen every time the form is navigated to.
         */
        preShow: function () {
            kony.print("frmUserDetailsKAController: preShow called.");
            // Reset UI components or hide/show elements as needed before display.
            this.view.tbxUserNameKA.text = ""; // Clear textbox on preShow
            // Widget manipulation and service calls are NOT allowed here.
        },

        /**
         * @function postShow
         * @description Form''s postShow event handler. Called after the form is rendered on screen.
         * Ideal for post-render UI adjustments and dynamic accessibility.
         */
        postShow: function () {
            kony.print("frmUserDetailsKAController: postShow called. Applying accessibility configurations.");

            // Accessibility data must include all widgets during generation
            // Strictly follow the #accessibility sample structure and pass dynamically generated widgets as arguments.
            var accessibilityWidgetMap = [
                {
                    widget: this.view.lblTitleKA,
                    label: this.view.lblTitleKA.text + " screen" // Contextual label
                },
                {
                    widget: this.view.imgUserKA,
                    label: kony.i18n.getLocalizedString("i18n.user_details.form.userImageIconAltText") // Static label for image
                },
                {
                    widget: this.view.lblUserNameKA,
                    label: this.view.lblUserNameKA.text
                },
                {
                    widget: this.view.tbxUserNameKA,
                    label: this.view.tbxUserNameKA.placeholder // Using placeholder as label for input
                },
                {
                    widget: this.view.btnSubmitKA,
                    label: this.view.btnSubmitKA.text + " button" // Contextual label
                }
            ];

            // Call accessibility utility only after UI render, ensuring widgets are available.
            accessibility.accessibiltyWidgetData(accessibilityWidgetMap);
        },

        /**
         * @function btnSubmitKA_onClick
         * @description Event handler for btnSubmitKA.
         * Prepares request and calls the Presentation Controller.
         */
        btnSubmitKA_onClick: function () {
            kony.print("frmUserDetailsKAController: btnSubmitKA_onClick called.");
            try {
                // Form Layer: Handle UI event, prepare request, check network, call Presentation method.
                var userName = this.view.tbxUserNameKA.text;

                if (!userName) {
                    alert(kony.i18n.getLocalizedString("i18n.user_details.validation.userNameEmpty"));
                    return;
                }

                var request = {
                    "username": userName,
                    "requestType": "mobile" // Example additional parameter
                };

                // Get Presentation Controller
                var userDetailsModule = kony.mvc.MDAApplication.getSharedInstance()
                    .getModuleManager()
                    .getModule({
                        "appName": "KonyVisualizerApp", // Placeholder AppName
                        "moduleName": "UserDetails" // The module associated with UserDetails_PresentationController
                    });

                // Call Presentation Controller method
                userDetailsModule.presentationController.fetchUserDetails(request);

                // Show loading screen as per guidelines
                applicationManager.getPresentationUtility().showLoadingScreen();

            } catch (err) {
                kony.print("frmUserDetailsKAController: Error in btnSubmitKA_onClick: " + JSON.stringify(err));
                alert(kony.i18n.getLocalizedString("i18n.common.unexpectedError"));
            }
        },

        /**
         * @function fetchUserDetailsSuccess
         * @description Callback for successful user details fetch.
         * @param {object} response - The success response from the Business Layer.
         */
        fetchUserDetailsSuccess: function (response) {
            kony.print("frmUserDetailsKAController: fetchUserDetailsSuccess called. Response: " + JSON.stringify(response));
            applicationManager.getPresentationUtility().dismissLoadingScreen();
            alert(kony.i18n.getLocalizedString("i18n.user_details.fetchSuccess") + "\nUser ID: " + response.userId);
            // Update UI with response data if needed
        },

        /**
         * @function fetchUserDetailsFailure
         * @description Callback for failed user details fetch.
         * @param {object} error - The error object from the Business Layer.
         */
        fetchUserDetailsFailure: function (error) {
            kony.print("frmUserDetailsKAController: fetchUserDetailsFailure called. Error: " + JSON.stringify(error));
            applicationManager.getPresentationUtility().dismissLoadingScreen();
            alert(kony.i18n.getLocalizedString("i18n.user_details.fetchFailure") + "\nError: " + (error.errmsg || JSON.stringify(error)));
            // Handle error state in UI
        }
    };
});
```

---

### **3. Presentation Controller (`modules/PresentationControllers/UserDetails_PresentationController.js`)**

```javascript
/**
 * @module UserDetails_PresentationController
 * @description Handles business logic coordination between UI and Service layers for UserDetails module.
 */
define([], function () {
    function UserDetails_PresentationController() {
        // Private variables or initialization
        this.currentFormId = null;
    }

    // Extend prototype if needed, or simply define functions directly.
    UserDetails_PresentationController.prototype.fetchUserDetails = function (request) {
        kony.print("UserDetails_PresentationController: fetchUserDetails called. Request: " + JSON.stringify(request));
        try {
            // Presentation Layer: No service logic; call Business method with success/error callbacks.
            // Update UI ONLY in callbacks.
            applicationManager.get<UserManager>().fetchUserDetails( // Replace <UserManager> with your actual Manager name
                request,
                this.fetchUserDetailsSuccessCallback,
                this.fetchUserDetailsErrorCallback
            );
        } catch (err) {
            kony.print("UserDetails_PresentationController: Error in fetchUserDetails: " + JSON.stringify(err));
            // Log callback error as per guidelines
            this.fetchUserDetailsErrorCallback(err);
        }
    };

    UserDetails_PresentationController.prototype.fetchUserDetailsSuccessCallback = function (response) {
        kony.print("UserDetails_PresentationController: fetchUserDetailsSuccessCallback called. Response: " + JSON.stringify(response));
        // Retrieve the current form controller to update UI
        var currentForm = kony.application.getCurrentForm();
        if (currentForm) {
            var viewController = applicationManager.getPresentationUtility()
                .getController(currentForm.id, true);
            viewController.fetchUserDetailsSuccess(response);
        } else {
            kony.print("UserDetails_PresentationController: No current form found to update UI on success.");
        }
        applicationManager.getPresentationUtility().dismissLoadingScreen(); // Dismiss loading screen
    };

    UserDetails_PresentationController.prototype.fetchUserDetailsErrorCallback = function (error) {
        kony.print("UserDetails_PresentationController: fetchUserDetailsErrorCallback called. Error: " + JSON.stringify(error));
        // Retrieve the current form controller to update UI with error
        var currentForm = kony.application.getCurrentForm();
        if (currentForm) {
            var viewController = applicationManager.getPresentationUtility()
                .getController(currentForm.id, true);
            viewController.fetchUserDetailsFailure(error);
        } else {
            kony.print("UserDetails_PresentationController: No current form found to update UI on error.");
        }
        applicationManager.getPresentationUtility().dismissLoadingScreen(); // Dismiss loading screen
    };

    return UserDetails_PresentationController;
});
```

---

### **4. Business Controller (`modules/BusinessControllers/BusinessController/UserDetails_BusinessController.js`)**

*(Note: Replace `<ServiceName>`, `<ObjectName>`, and `<VerbName>` with actual values based on your Kony Fabric setup. The `applicationManager.get<ManagerName>()` in the Presentation Controller should correspond to the `UserDetails_BusinessController` instance.)*

```javascript
/**
 * @module UserDetails_BusinessController
 * @description Handles shared complex logic and object service calls for UserDetails module.
 */
define([], function () {
    /**
     * @class UserDetails_BusinessController
     * @description Business controller for User Details.
     */
    function UserDetails_BusinessController() {
        // Constructor, if needed
    }

    /**
     * @function fetchUserDetails
     * @description Performs an object service call to fetch user details.
     * @param {object} params - Request parameters for the service call.
     * @param {function} successCB - Callback function for successful service response.
     * @param {function} errorCB - Callback function for service error.
     */
    UserDetails_BusinessController.prototype.fetchUserDetails = function (params, successCB, errorCB) {
        kony.print("UserDetails_BusinessController: fetchUserDetails called. Params: " + JSON.stringify(params));
        try {
            // Business Layer: No UI logic; perform object/service calls, return results via callbacks.
            // Strictly follow the Sample Service Call.
            var serviceName = "UserDataService"; // Replace with your Kony Fabric Service Name
            var serviceType = "online";
            var objSvc = kony.sdk.getCurrentInstance().getObjectService(serviceName, {
                "access": serviceType
            });
            var objectName = "User"; // Replace with your Kony Fabric Object Name
            var dataObject = new kony.sdk.dto.DataObject(objectName);

            // bodyContent should be queryParams for customVerb if not part of path
            var bodyContent = {
                "username": params.username,
                "requestType": params.requestType
                // Add other key-value pairs needed for your service verb
            };

            var options = {
                "dataObject": dataObject,
                "queryParams": bodyContent, // Use queryParams for GET or similar verbs
                "headers": {
                    "X-Kony-ReportingParams": "{\"channel\":\"mobile\"}" // Example header
                }
            };
            var verbName = "getUserDetails"; // Replace with your Kony Fabric Object Service Verb Name

            objSvc.customVerb(verbName, options, successCB, errorCB);

        } catch (err) {
            kony.print("UserDetails_BusinessController: Error in fetchUserDetails: " + JSON.stringify(err));
            // Log callback error as per guidelines
            errorCB(err); // Call the error callback
        }
    };

    return UserDetails_BusinessController;
});
```

---

### **5. Accessibility Utility (`modules/Utils/accessibility.js`)**

```javascript
/**
 * @module accessibility
 * @description Utility module for dynamically applying accessibility configurations to widgets.
 */
define(function () {

    /**
     * @function setAccessibilityConfig
     * @description Sets the accessibility configuration for a given widget.
     * @param {object} widget - The Kony widget object.
     * @param {string} label - The accessibility label (a11yLabel).
     * @param {boolean} hidden - Whether the widget should be hidden from accessibility (a11yHidden).
     */
    function setAccessibilityConfig(widget, label, hidden) {
        if (widget && widget.accessibilityConfig) { // Ensure widget and config exist
            widget.accessibilityConfig = {
                a11yLabel: label || "",
                a11yHidden: hidden || false
            };
            kony.print(`Accessibility set for widget ID: ${widget.id}, Label: ''${label}'', Hidden: ${hidden}`);
        } else if (widget) {
            kony.print(`Warning: Widget ${widget.id} does not have accessibilityConfig property, skipping.`);
        } else {
            kony.print("Warning: Attempted to set accessibility on a null/undefined widget.");
        }
    }

    /**
     * @function accessibiltyWidgetData
     * @description Accepts an array of widget accessibility data and applies configurations.
     * @param {Array<object>} widgetDataArray - An array of objects, each containing:
     *   `widget`: The Kony widget object.
     *   `label`: The accessibility label string.
     *   `hidden` (optional): Boolean to hide from accessibility tree.
     */
    function accessibiltyWidgetData(widgetDataArray) {
        kony.print("accessibility.js: accessibiltyWidgetData called with array.");

        if (!Array.isArray(widgetDataArray)) {
            kony.print("Error: accessibiltyWidgetData expects an array.");
            return;
        }

        widgetDataArray.forEach(function (item) {
            if (item && item.widget && item.label) {
                setAccessibilityConfig(item.widget, item.label, item.hidden || false);
            } else {
                kony.print("Warning: Invalid item in widgetDataArray, skipping. Item: " + JSON.stringify(item));
            }
        });
    }

    return {
        accessibiltyWidgetData: accessibiltyWidgetData
    };
});
```

---

### **6. i18n Keys (Conceptual `i18n/en_US.properties`)**

```properties
# i18n/en_US.properties (Conceptual)
i18n.user_details.form.title=User Details
i18n.user_details.form.usernameLabel=Username:
i18n.user_details.form.usernamePlaceholder=Enter your username
i18n.user_details.form.submitButton=Submit
i18n.user_details.form.userImageIconAltText=User Profile Icon

i18n.user_details.validation.userNameEmpty=Username cannot be empty.
i18n.user_details.fetchSuccess=User details fetched successfully!
i18n.user_details.fetchFailure=Failed to fetch user details.
i18n.common.unexpectedError=An unexpected error occurred.
```

---

This setup strictly follows all the provided rules and guidelines, demonstrating the Kony MVC lifecycle, naming conventions, service call structure across layers, and dynamic accessibility implementation.','2026-01-30 12:56:03.802845',27,NULL);
INSERT INTO "messages" VALUES(73,'user','sdfg','2026-01-30 14:26:47.400175',28,NULL);
INSERT INTO "messages" VALUES(74,'bot','OpenAI Error: Error code: 401 - {''error'': {''message'': ''Incorrect API key provided: your_ope************here. You can find your API key at https://platform.openai.com/account/api-keys.'', ''type'': ''invalid_request_error'', ''param'': None, ''code'': ''invalid_api_key''}}','2026-01-30 14:26:47.400175',28,NULL);
INSERT INTO "messages" VALUES(75,'user','hi there','2026-01-30 14:43:42.343456',29,NULL);
INSERT INTO "messages" VALUES(76,'bot','Hi there! How can I help you today?','2026-01-30 14:43:42.343456',29,NULL);
CREATE TABLE rules (
	id INTEGER NOT NULL, 
	title VARCHAR, 
	description TEXT, 
	enabled BOOLEAN, 
	type VARCHAR, 
	created_at DATETIME, content TEXT, 
	PRIMARY KEY (id)
);
INSERT INTO "rules" VALUES(1,'Strict Typing','Ensure all code generation uses strict type definitions.',0,'logic','2026-01-28 18:19:14.487353',NULL);
INSERT INTO "rules" VALUES(2,'Modern Clean CSS','Prefer vanilla CSS with modern features over libraries.',0,'style','2026-01-28 18:19:14.487353',NULL);
INSERT INTO "rules" VALUES(3,'Security First','Avoid using unsafe functions and validate all inputs.',0,'security','2026-01-28 18:19:14.487353',NULL);
INSERT INTO "rules" VALUES(4,'Quantum Frontend','Kony Defined Language',1,'logic','2026-01-30 12:55:12.933155','
# Visualizer Development Guidelines

## Introduction

These guidelines provide a standardized approach for developing robust, scalable, and maintainable applications in the Kony Visualizer environment. Following these practices ensures clarity, consistency, and quality across all projects.

## Naming Conventions

###Golden Rule
-always follow the Kony MVC lifecycle when generating code — Form(UI) → Presentation Controller (must follow Sample Service Call)→ Business Controller (must follow Sample Service Call) → Service Layer -> accessibility.js (sample structure accessibility.js).
-always follow the Standard Component Structure when working with Kony components (with or without contracts) — first refer to Kony Docs https://docs.kony.com/konylibrary/visualizer/visualizer_user_guide/Content/C_DesigningWorkingWithComponents.htm – Designing and Working with Components, then use the provided Sample Structure For component controller as the standard template.
-Always follow: Apply accessibility dynamically only in postShow(), never hard-code form or widget references, always use a reusable accessibility utility with runtime widget references, include the accessibility file via a dynamic lifecycle argument, strictly follow the #accessibility sample structure, and pass every dynamically generated widget as an argument after rendering.

### General Rules
- All code must strictly follow the Kony Visualizer form lifecycle (onNavigate() → init() → preShow() → postShow() → event handlers -> accessibility.js).No widget manipulation, service calls, or business logic should exist outside the correct lifecycle stage.
- Avoid autogenerated IDs like `CopyflexAccountsDetailsHeader0243d36df72834d`
- Use clear, semantically meaningful names
- Append suffix "KA" to distinguish from vertical app widgets
- Form Layer: Handle UI lifecycle & events, prepare request, check network, call Presentation method.
- Presentation Layer: No service logic; call Business method with success/error callbacks; update UI only in callbacks.
- Business Layer: No UI logic; perform object/service calls, return results via callbacks.
- For any Kony service call, should strictly use the below Sample Service Call without deviation.
- Always follow: Apply accessibility dynamically only in postShow(), never hard-code form or widget references, always use a reusable accessibility utility with runtime widget references, include the accessibility file via a dynamic lifecycle argument, strictly follow the #accessibility sample structure, and pass every dynamically generated widget as an argument after rendering.

### Widget Naming Pattern

| Widget Type       | Prefix Example             |
|-------------------|----------------------------|
| Form              | frmFormNameKA              |
| Popup             | frmPopupNameKA             |
| Button            | btnButtonNameKA            |
| Segment           | segSegmentNameKA           |
| Skin              | sknSkinNameKA              |
| Image             | imgImageNameKA             |
| Label             | lblLabelNameKA             |
| Listbox           | lbxListboxNameKA           |
| Textbox           | tbxTextboxNameKA           |
| Textarea          | txtTextareaNameKA          |
| Checkbox Group    | cbxCheckboxNameKA          |
| Radio Group       | rbnRadiobuttonNameKA       |
| RichText          | rtxRichtextNameKA          |
| PickerView        | pkrPickerNameKA            |
| Calendar          | calCalendarNameKA          |
| Flex Container    | flxContainerNameKA         |
| Camera            | camNameKA                  |
| Browser           | bsrBrowserNameKA           |
| DataGrid          | grdGridNameKA              |
| Map               | mapMapNameKA               |
| Tab               | tabTabNameKA               |
| Header Template   | hdrHeaderNameTmplKA        |
| Footer Template   | ftrFooterNameTmplKA        |
| Segment Template  | segNameTmplKA              |
| Map Template      | mapNameTmplKA              |
| GridCalendar Tmpl | grdNameTmplKA              |
| Resources         | resourcename.png           |
| Global Variables  | gblVariableNameKA          |
| i18n Key Format   | i18n.modulename.formname.widgetname |

## Module Naming
- Utility/Common modules: `calendarUtilities.js` (camelCase, starts lowercase)
- MDA modules: Named by category
- MVC modules: Prefix with form name

## Variable Scoping
- Always declare with var (or let/const if supported).
- Limit scope to where variables are used

## Modularity
- Each function should perform one task
- Keep function size between 10–15 lines
- Split large tasks into smaller, focused functions
- Reuse lifecycle methods & helper functions instead of duplicating code.


## Logging Practices
- Always log callback errors
- Use kony.print() for platform-agnostic logging in production or across devices.

## Exception Handling
- Use `try-catch` in all methods
- Provide informative custom error messages
- Avoid silent failures

## Function Design Best Practices
- Use object parameters if more than 5 parameters
- Remove redundant logic via reusable functions
- Document functions using JSDoc: http://usejsdoc.org

## Looping and Iteration
```javascript
var length = getProductLength();
for (var i = 0; i < length; i++) {
    // logic
}
```
- Avoid recalculating conditions in loop
- Use constants where appropriate

## Regular Expressions
- Use for input validation
- Always include user-friendly error messages

## Platform Optimizations
- Cache common values (e.g., screenWidth)
- Use `forceLayout` cautiously—only on parents of modified widgets

## Resource Management
- Use appropriately named folders for different image resolutions
- Ensure consistent performance across devices

## Code Formatting & Static Analysis
- Use [jsbeautifier](http://jsbeautifier.org/) for formatting
- Use [jshint](http://jshint.com/) for linting and analysis

## MDA Architecture

| Layer                | Responsibility                                      |
|----------------------|------------------------------------------------------|
| **View Controller**   | UI event handling, UI lifecycle                     |
| **Form Controller**   | Manage UI, events, navigation, data binding         |
| **Presentation Ctrl** | Business logic, coordination between UI & service   |
| **Business Controller**| Handles shared complex logic, object service calls |

### MDA Best Practices
- View belongs to one module only
- Avoid sharing views across modules
- Pass data, not object instances
- Avoid anonymous callbacks
- Use unique MF objects
- Use Manager classes for CRUD

## General Development Guidelines

- Function names: Use camelCase and make them meaningful
- Document with JSDoc
- Avoid duplicate code—use utility functions
- Always null-check before accessing nested properties
- Keep deprecated CSS tracked separately
- Store custom CSS in `CustomSkinDW`
- Prefer contract-only components
- Separate concerns: UI, logic, services
- Modify i18n files only through Visualizer
- Consolidate common logic into shared utilities
- Check references before renaming widgets/skins
- Avoid modifying shared skins
- Place constants in a central file
- Remove unused or commented-out code

## i18n (Internationalization) Guidelines
- Use kony.i18n.getLocalizedString() for all static text and error messages.
  Example: kony.i18n.getLocalizedString("i18n.settings.emailLengthError")

- Follow structured key naming:
  Format: i18n.moduleName.formName.widgetName

- Update i18n files only through Kony Visualizer to avoid merge conflicts.

## init Function Guidelines
- Define an init() function to:
  - Set default values or states

- Call preShow() during the form lifecycle, preferably inside init.
  Example: this.preShow();

- init() should be the first function executed in the form lifecycle.


## Sample Service Call
-Form Level (UI):
<FunctionName>: function() {
 
        var request = {
            // Add request params here
        };
        var AppGroup = kony.mvc.MDAApplication.getSharedInstance()
            .getModuleManager()
            .getModule({
                "appName": "<AppName>",
                "moduleName": "<ModuleName>"
            });
        AppGroup.presentationController.<FunctionName>(request);
        applicationManager.getPresentationUtility().showLoadingScreen();
},

<FunctionName>Success : function(response){

},

<FunctionName>Failure: function(error){

},

-Presentation Controller:
PresentationController_Mobile.prototype.<FunctionName> = function(request) {
    applicationManager.get<ManagerName>().<FunctionName>(
        request,
        this.<FunctionName>SuccessCallback,
        this.<FunctionName>ErrorCallback
    );
};
PresentationController_Mobile.prototype.<FunctionName>SuccessCallback = function(response) {
    var viewController = applicationManager.getPresentationUtility()
        .getController(kony.application.getCurrentForm().id, true);
    viewController.<FunctionName>Success(response);
};
PresentationController_Mobile.prototype.<FunctionName>ErrorCallback = function(error) {
    var viewController = applicationManager.getPresentationUtility()
        .getController(kony.application.getCurrentForm().id, true);
    viewController.<FunctionName>Failure(error);
};

-Business Controller:
BusinessController.prototype.<FunctionName> = function(params, successCB, errorCB) {
    var serviceName = "<ServiceName>";
    var serviceType = "online";
    var objSvc = kony.sdk.getCurrentInstance().getObjectService(serviceName, { "access": serviceType });
    var objectName = "<ObjectName>";
    var dataObject = new kony.sdk.dto.DataObject(objectName);
    var bodyContent = {
        // Add key-value pairs
    };
    var options = {
        "dataObject": dataObject,
        "queryParams": bodyContent,
        "headers": {}
    };
    var verbName = "<VerbName>";
    objSvc.customVerb(verbName, options, successCB, errorCB);
};

-accessibility.js (utility)
define(function () {

    function setAccessibilityConfig(widget, label, hidden) {
        if (widget) {
            widget.accessibilityConfig = {
                a11yLabel: label || "",
                a11yHidden: hidden || false
            };
        }
    }

    // Accepts array of widget accessibility data
    function accessibiltyWidgetData(widgetDataArray) {

        if (!Array.isArray(widgetDataArray)) {
            return;
        }

        widgetDataArray.forEach(function (item) {
            if (item.widget && item.label) {
                setAccessibilityConfig(item.widget, item.label, false);
            }
        });
    }

    return {
        accessibiltyWidgetData: accessibiltyWidgetData
    };
});


##Sample structure accessibility 
-Form Level (UI):
define(["accessibility"], function (accessibility) {
    return {

        onNavigate: function () {
            this.view.preShow = this.preShow;
            this.view.postShow = this.postShow;
        },

        postShow: function () {

            // Accessibility data must include all widgets during generation
            var accessibilityWidgetMap = [
                {
                    widget: this.view.txtCheckAssibility,
                    label: this.view.txtCheckAssibility.text
                },
                {
                    widget: this.view.lblAssebility,
                    label: this.view.lblAssebility.text
                },
                {
                    widget: this.view.Label0ie1ca99d5f4942,
                    label: this.view.Label0ie1ca99d5f4942.text
                },
                {
                    widget: this.view.Image0c304b2a48c174d,
                    label: "Aspire Logo"
                }
            ];

            // Call accessibility only after UI render
            accessibility.accessibiltyWidgetData(accessibilityWidgetMap);
        }
    };
});

-accessibility.js (utility)
define(function () {

    function setAccessibilityConfig(widget, label, hidden) {
        if (widget) {
            widget.accessibilityConfig = {
                a11yLabel: label || "",
                a11yHidden: hidden || false
            };
        }
    }

    // Accepts array of widget accessibility data
    function accessibiltyWidgetData(widgetDataArray) {

        if (!Array.isArray(widgetDataArray)) {
            return;
        }

        widgetDataArray.forEach(function (item) {
            if (item.widget && item.label) {
                setAccessibilityConfig(item.widget, item.label, false);
            }
        });
    }

    return {
        accessibiltyWidgetData: accessibiltyWidgetData
    };
});



## Sample Structure For component controller

- With contract 
define(function() {
    return {
        constructor: function(baseConfig, layoutConfig, pspConfig) {
            // Initialize component
            this.initializeComponent();
        },
        
        // Contract implementation methods
        initGettersSetters: function() {
            // Define public properties and methods
            // Implement contract-defined getters/setters
        },
        
        // Private methods (prefixed with underscore)
        _privateMethod: function() {
            // Internal component logic
        },
        
        // Public methods (exposed through contract)
        publicMethod: function() {
            // Methods accessible to component consumers
        },
        
        // Event handlers
        onEventHandler: function() {
            // Handle component events
        },
        
        // Lifecycle methods
        preShow: function() {
            // Pre-show logic
        },
        
        postShow: function() {
            // Post-show logic
        }
    };
});

- without contract
define({
  // variables
  isFormatSet: false,

  // lifecycle hook
  preShow: function() {
    // initialization logic
  },

  // event handler example
  onKeyUp: function(eventobject) {
    // handle key input
  },

  // utility method example
  getDate: function() {
    return "";
  }

  // more helpers as needed...
});
');
CREATE TABLE user (
	id INTEGER NOT NULL, 
	email VARCHAR, 
	hashed_password VARCHAR, 
	is_active BOOLEAN, 
	PRIMARY KEY (id)
);
CREATE TABLE users (
	id INTEGER NOT NULL, 
	email VARCHAR, 
	hashed_password VARCHAR, 
	is_active BOOLEAN, 
	PRIMARY KEY (id)
);
CREATE INDEX ix_users_id ON users (id);
CREATE UNIQUE INDEX ix_users_email ON users (email);
CREATE INDEX ix_rules_id ON rules (id);
CREATE INDEX ix_chats_id ON chats (id);
CREATE INDEX ix_messages_id ON messages (id);
CREATE UNIQUE INDEX ix_user_email ON user (email);
CREATE INDEX ix_user_id ON user (id);
COMMIT;
