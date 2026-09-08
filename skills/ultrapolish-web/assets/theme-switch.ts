/**
 * theme-switch.ts
 *
 * Light / dark / system theming with a one-frame transition suppressor so a
 * switch reads as one change, not a ripple of mismatched fades. Rename
 * STORAGE_KEY to the project's key. Carries no palette; the colours live in
 * the project's own CSS variables under [data-theme].
 *
 * Companion CSS (add to the global stylesheet):
 *
 *   .theme-switching,
 *   .theme-switching *,
 *   .theme-switching *::before,
 *   .theme-switching *::after {
 *     transition: none !important;
 *   }
 *
 * Usage:
 *   1. Inject `themeInitScript` as an inline <script> in <head>, before any
 *      stylesheet paints, so the first frame is already the right theme.
 *   2. Call `followSystemTheme()` once on mount and keep the returned cleanup.
 *   3. Read the preference in React with `useThemePref()`; write with `setThemePref()`.
 */

import { useSyncExternalStore } from "react";

export type Theme = "light" | "dark" | "system";

/** Rename per project. The same key must appear in themeInitScript below. */
export const STORAGE_KEY = "theme";

const CLASS_SWITCHING = "theme-switching";
const BACKSTOP_MS = 120;
const listeners = new Set<() => void>();

function notify(): void {
  for (const fn of listeners) fn();
}

/**
 * "system" is the ABSENCE of a stored value, not a stored string. Browsers
 * that never chose keep their historic behaviour, and clearing the key is
 * the same as choosing system.
 */
export function themePref(): Theme {
  try {
    const s = localStorage.getItem(STORAGE_KEY);
    return s === "dark" ? "dark" : s === "light" ? "light" : "system";
  } catch {
    return "system";
  }
}

function systemIsDark(): boolean {
  return window.matchMedia("(prefers-color-scheme: dark)").matches;
}

/**
 * Paint the document under the one-frame suppressor. Cleared on a double
 * requestAnimationFrame, with a timer as backstop: rAF does not fire in a
 * background tab, and without the fallback a theme switched while hidden
 * would leave every transition disabled for the rest of the session.
 */
export function applyTheme(dark: boolean): void {
  const root = document.documentElement;
  root.classList.add(CLASS_SWITCHING);
  root.dataset.theme = dark ? "dark" : "light";
  const clear = () => root.classList.remove(CLASS_SWITCHING);
  requestAnimationFrame(() => requestAnimationFrame(clear));
  setTimeout(clear, BACKSTOP_MS);
}

export function setThemePref(pref: Theme): void {
  try {
    if (pref === "system") localStorage.removeItem(STORAGE_KEY);
    else localStorage.setItem(STORAGE_KEY, pref);
  } catch {
    /* Private mode: the choice simply will not persist. */
  }
  applyTheme(pref === "system" ? systemIsDark() : pref === "dark");
  notify();
}

/** Resolved appearance right now, regardless of preference. */
export function resolvedTheme(): "light" | "dark" {
  const pref = themePref();
  if (pref === "system") return systemIsDark() ? "dark" : "light";
  return pref;
}

export function subscribe(onChange: () => void): () => void {
  listeners.add(onChange);
  return () => {
    listeners.delete(onChange);
  };
}

export function getSnapshot(): Theme {
  return themePref();
}

const getServerSnapshot = (): Theme => "system";

/** The stored preference, live. Every control reading it stays in agreement. */
export function useThemePref(): Theme {
  return useSyncExternalStore(subscribe, getSnapshot, getServerSnapshot);
}

/**
 * While the preference is system, follow the OS as it changes mid-session.
 * Mount once; keep the cleanup.
 */
export function followSystemTheme(): () => void {
  const mq = window.matchMedia("(prefers-color-scheme: dark)");
  const on = () => {
    if (themePref() === "system") {
      applyTheme(mq.matches);
      notify();
    }
  };
  mq.addEventListener("change", on);
  return () => mq.removeEventListener("change", on);
}

/**
 * Inline this in <head> before stylesheets so the first paint is already the
 * right theme. Keep STORAGE_KEY in sync with the constant above.
 */
export const themeInitScript = `(function(){try{var k=${JSON.stringify(
  STORAGE_KEY,
)};var s=localStorage.getItem(k);var d=s==="dark"||(s!=="light"&&matchMedia("(prefers-color-scheme: dark)").matches);document.documentElement.dataset.theme=d?"dark":"light"}catch(e){}})();`;
