# Vis3

**Category:** logic
**Version:** 1.0
**Priority:** medium
**Description:** 

## Rule Content
// 1. Create a new Date object
//    This object automatically holds the current date and time when created.
const now = new Date();

console.log("---------------------------------------");
console.log("Current Date and Time (Raw Date object):");
console.log(now); // Outputs something like: "Tue Jun 25 2024 10:30:00 GMT-0400 (Eastern Daylight Time)"

console.log("\n---------------------------------------");
console.log("Common Formats:");

// 2. Convert to a readable string (local time zone)
console.log("1. Default string (toLocaleString):");
console.log(now.toLocaleString()); // Outputs something like: "6/25/2024, 10:30:00 AM" (varies by locale)

// 3. Get specific parts
console.log("\n2. Getting specific parts:");
console.log("   Year: " + now.getFullYear());        // e.g., 2024
console.log("   Month (0-11): " + now.getMonth());    // e.g., 5 for June (add 1 for human-readable month)
console.log("   Day of month: " + now.getDate());     // e.g., 25
console.log("   Day of week (0-6): " + now.getDay());  // e.g., 2 for Tuesday (0 is Sunday)
console.log("   Hours: " + now.getHours());          // e.g., 10 (0-23)
console.log("   Minutes: " + now.getMinutes());        // e.g., 30
console.log("   Seconds: " + now.getSeconds());        // e.g., 0
console.log("   Milliseconds: " + now.getMilliseconds()); // e.g., 0
console.log("   Unix Timestamp (ms since Jan 1, 1970 UTC): " + now.getTime()); // e.g., 1719325800000

// 4. ISO 8601 string (useful for consistent data storage/transfer)
console.log("\n3. ISO 8601 string (UTC):");
console.log(now.toISOString()); // Outputs something like: "2024-06-25T14:30:00.000Z" (always UTC)

// 5. Date-only and Time-only strings (locale-aware)
console.log("\n4. Date-only and Time-only (toLocaleString with options):");
console.log("   Date only: " + now.toLocaleDateString()); // e.g., "6/25/2024"
console.log("   Time only: " + now.toLocaleTimeString()); // e.g., "10:30:00 AM"

// 6. Custom formatted string using template literals and padding
const year = now.getFullYear();
const month = (now.getMonth() + 1).toString().padStart(2, '0'); // +1 because months are 0-indexed
const day = now.getDate().toString().padStart(2, '0');
const hours = now.getHours().toString().padStart(2, '0');
const minutes = now.getMinutes().toString().padStart(2, '0');
const seconds = now.getSeconds().toString().padStart(2, '0');

console.log("\n5. Custom formatted string (YYYY-MM-DD HH:MM:SS):");
console.log(`${year}-${month}-${day} ${hours}:${minutes}:${seconds}`); // e.g., "2024-06-25 10:30:00"

console.log("---------------------------------------");