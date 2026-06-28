import { createBdd } from 'playwright-bdd';
import { expect } from '@playwright/test';

const { Given, Then } = createBdd();

Given('I am on the home page', async ({ page }) => {
  await page.goto('/');
  await expect(page.locator('.hex-cluster')).toBeVisible({ timeout: 15_000 });
});

Then('the Ubuntu distro tile links to its benchmarks page', async ({ page }) => {
  await expect(page.locator('a.hex-tile[href="/benchmarks/ubuntu/"]')).toBeVisible();
});

Then('the Fedora distro tile links to its benchmarks page', async ({ page }) => {
  await expect(page.locator('a.hex-tile[href="/benchmarks/fedora/"]')).toBeVisible();
});

Then('the Debian distro tile links to its benchmarks page', async ({ page }) => {
  await expect(page.locator('a.hex-tile[href="/benchmarks/debian/"]')).toBeVisible();
});

Then('the benchmark data panel shows {int} rows', async ({ page }, count) => {
  await expect(page.locator('.data-panel .data-row')).toHaveCount(count);
});

Then('the C-Ray row shows the mean value {string}', async ({ page }, value) => {
  const crayRow = page.locator('.data-row').filter({ hasText: 'C-Ray' });
  await expect(crayRow.locator('.data-value')).toContainText(value);
});

Given('I navigate to the Ubuntu benchmarks page', async ({ page }) => {
  await page.goto('/benchmarks/ubuntu/');
  await expect(page.locator('a.back-link')).toBeVisible({ timeout: 15_000 });
});

Then('the back link to overview is present', async ({ page }) => {
  await expect(page.locator('a.back-link')).toContainText(/OVERVIEW/i);
});

Then('the section navigation is visible', async ({ page }) => {
  await expect(page.locator('nav.section-nav')).toBeVisible();
});
