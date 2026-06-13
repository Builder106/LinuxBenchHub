import { defineConfig } from "vitest/config";

// Unit tests for the site's pure logic — primarily the benchmark-markdown
// parser in lib/. Node environment (no DOM needed); add jsdom + RTL later if
// component tests are introduced.
export default defineConfig({
  test: {
    environment: "node",
    include: ["lib/**/*.test.ts", "app/**/*.test.ts"],
  },
});
