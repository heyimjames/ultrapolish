/**
 * motion.ts
 *
 * Motion tokens for `motion/react` (the package formerly published as
 * `framer-motion`; if the project still imports from "framer-motion", change
 * the import below and nothing else). Shares physics with motion.css via
 * gen-springs.mjs. Rename the token keys to match the design contract if it
 * names them. Carries no palette or typeface.
 */

import { useReducedMotion } from "motion/react";

export type SpringToken = "micro" | "snappy" | "smooth" | "bouncy" | "gentle";
export type TweenToken = "micro" | "ui" | "overlay" | "page";

export interface SpringTransition {
  type: "spring";
  visualDuration: number;
  bounce: number;
}

export interface TweenTransition {
  type: "tween";
  duration: number;
  ease: [number, number, number, number];
}

export type Transition = SpringTransition | TweenTransition | { duration: 0 };

/** Springs for anything with mass or anything a gesture can interrupt. */
export const SPRING: Record<SpringToken, SpringTransition> = {
  micro:  { type: "spring", visualDuration: 0.2,  bounce: 0.12 },
  snappy: { type: "spring", visualDuration: 0.3,  bounce: 0.18 },
  smooth: { type: "spring", visualDuration: 0.4,  bounce: 0 },
  bouncy: { type: "spring", visualDuration: 0.35, bounce: 0.32 },
  gentle: { type: "spring", visualDuration: 0.6,  bounce: 0 },
};

const EASE_ENTER: [number, number, number, number] = [0.16, 1, 0.3, 1];
const EASE_EXIT: [number, number, number, number] = [0.4, 0, 1, 1];

/** Tweens for colour, opacity, and anything that must not overshoot. */
export const TWEEN: Record<TweenToken, TweenTransition> = {
  micro:   { type: "tween", duration: 0.12, ease: EASE_ENTER },
  ui:      { type: "tween", duration: 0.2,  ease: EASE_ENTER },
  overlay: { type: "tween", duration: 0.26, ease: EASE_ENTER },
  page:    { type: "tween", duration: 0.34, ease: EASE_ENTER },
};

/** Opacity never springs. Use this for fades paired with a spring on transform. */
export const FADE: TweenTransition = { type: "tween", duration: 0.2, ease: EASE_ENTER };

/** Exit at 0.65x the entrance, no bounce. Works for springs and tweens. */
export function exitOf(t: SpringTransition): SpringTransition;
export function exitOf(t: TweenTransition): TweenTransition;
export function exitOf(t: SpringTransition | TweenTransition): SpringTransition | TweenTransition {
  if (t.type === "spring") {
    return { type: "spring", visualDuration: round(t.visualDuration * 0.65), bounce: 0 };
  }
  return { type: "tween", duration: round(t.duration * 0.65), ease: EASE_EXIT };
}

/**
 * Stagger config for a parent variant. 36ms per child, capped at 8 children;
 * anything past that arrives after the user has already looked.
 */
export function staggerChildren(step = 0.036, max = 8, count?: number) {
  const n = count === undefined ? max : Math.min(count, max);
  return {
    staggerChildren: step,
    delayChildren: 0,
    /* Children beyond `max` share the last delay via this helper. */
    maxDelay: step * Math.max(0, n - 1),
  };
}

/** Delay for the i-th child under the same cap as staggerChildren. */
export function staggerDelay(i: number, step = 0.036, max = 8): number {
  return step * Math.min(i, max - 1);
}

export interface DismissInput {
  /** Drag offset along the dismiss axis. Positive = toward dismissal. */
  offset: number;
  /** Velocity along the same axis in px/s. Positive = toward dismissal. */
  velocity: number;
  /** Size of the surface along that axis, in px. */
  height: number;
}

const DISMISS_VELOCITY = 500;  // px/s
const DISMISS_DISTANCE = 0.5;  // fraction of height

/**
 * Velocity beats position. A fast flick dismisses from anywhere; a flick back
 * toward open always cancels; otherwise commit past half the height.
 */
export function shouldDismiss({ offset, velocity, height }: DismissInput): boolean {
  if (velocity < -DISMISS_VELOCITY) return false;
  if (velocity > DISMISS_VELOCITY) return true;
  return offset > height * DISMISS_DISTANCE;
}

/**
 * Rubber-band an overscroll offset. Asymptotic, so it feels like elastic and
 * not a wall. c = 0.55 is the platform constant.
 */
export function rubberBand(offset: number, dimension: number, c = 0.55): number {
  const sign = Math.sign(offset);
  const abs = Math.abs(offset);
  return sign * (1 - 1 / ((abs / dimension) * c + 1)) * dimension;
}

/**
 * Hook: the requested transition, or an instant one when the user prefers
 * reduced motion. Pair with a crossfade on opacity so the change still reads.
 */
export function usePick<T extends SpringTransition | TweenTransition>(t: T): T | { duration: 0 } {
  const reduce = useReducedMotion();
  return reduce ? { duration: 0 } : t;
}

/** Non-hook variant for callers that already know the preference. */
export function pick<T extends SpringTransition | TweenTransition>(t: T, reduce: boolean): T | { duration: 0 } {
  return reduce ? { duration: 0 } : t;
}

function round(n: number): number {
  return Math.round(n * 1000) / 1000;
}
