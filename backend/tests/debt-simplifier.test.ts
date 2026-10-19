import { describe, expect, it } from 'vitest';
import { computeBalances, MaxHeap, simplifyDebts } from '../src/services/debt-simplifier.js';

const settle = (entries: [string, number][]) => simplifyDebts(new Map(entries));

describe('MaxHeap', () => {
  it('pops entries largest first', () => {
    const heap = new MaxHeap();
    [5, 1, 9, 3, 7].forEach((amount, i) => heap.push({ member: `m${i}`, amount }));
    const order = [];
    while (heap.size) order.push(heap.pop()!.amount);
    expect(order).toEqual([9, 7, 5, 3, 1]);
  });
});

describe('simplifyDebts', () => {
  it('returns nothing when everyone is settled', () => {
    expect(settle([['a', 0], ['b', 0]])).toEqual([]);
  });

  it('handles one creditor with many debtors', () => {
    const transfers = settle([['a', 300], ['b', -100], ['c', -100], ['d', -100]]);
    expect(transfers).toHaveLength(3);
    expect(transfers.every((t) => t.to === 'a' && t.amountMinor === 100)).toBe(true);
  });

  it('cancels out circular debts', () => {
    // a owes b 10, b owes c 10, c owes a 10 -> net zero for all
    const balances = computeBalances(
      ['a', 'b', 'c'],
      [
        { paidBy: 'b', amountMinor: 10, shares: { a: 10 } },
        { paidBy: 'c', amountMinor: 10, shares: { b: 10 } },
        { paidBy: 'a', amountMinor: 10, shares: { c: 10 } },
      ],
      [],
    );
    expect(simplifyDebts(balances)).toEqual([]);
  });

  it('uses at most n - 1 transfers and conserves money', () => {
    const transfers = settle([['a', 500], ['b', 250], ['c', -400], ['d', -200], ['e', -150]]);
    expect(transfers.length).toBeLessThanOrEqual(4);
    const net = new Map<string, number>();
    for (const t of transfers) {
      net.set(t.from, (net.get(t.from) ?? 0) + t.amountMinor);
      net.set(t.to, (net.get(t.to) ?? 0) - t.amountMinor);
    }
    expect(net.get('a')).toBe(-500);
    expect(net.get('c')).toBe(400);
  });
});
