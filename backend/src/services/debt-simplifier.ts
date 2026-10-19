/**
 * Settles a group's balances with as few payments as the greedy strategy allows.
 *
 * Each step matches the largest creditor with the largest debtor and settles
 * min(credit, debt). One of the two always reaches zero, so the loop runs at most
 * n - 1 times and produces at most n - 1 transfers.
 *
 * Time:  O(n log n) - n heap pushes and up to 2(n - 1) pops/pushes.
 * Space: O(n) for the two heaps.
 *
 * Finding the true minimum number of transfers is NP-hard (it reduces to subset sum),
 * so the greedy result is the standard practical choice.
 */

export interface Transfer {
  from: string;
  to: string;
  amountMinor: number;
}

interface Entry {
  member: string;
  amount: number;
}

/** Binary max-heap ordered by amount, ties broken by member id so output is deterministic. */
export class MaxHeap {
  private readonly items: Entry[] = [];

  get size(): number {
    return this.items.length;
  }

  push(entry: Entry): void {
    this.items.push(entry);
    let i = this.items.length - 1;
    while (i > 0) {
      const parent = (i - 1) >> 1;
      if (!this.greater(i, parent)) break;
      this.swap(i, parent);
      i = parent;
    }
  }

  pop(): Entry | undefined {
    if (this.items.length === 0) return undefined;
    const top = this.items[0]!;
    const last = this.items.pop()!;
    if (this.items.length > 0) {
      this.items[0] = last;
      let i = 0;
      for (;;) {
        const left = 2 * i + 1;
        const right = left + 1;
        let largest = i;
        if (left < this.items.length && this.greater(left, largest)) largest = left;
        if (right < this.items.length && this.greater(right, largest)) largest = right;
        if (largest === i) break;
        this.swap(i, largest);
        i = largest;
      }
    }
    return top;
  }

  private greater(a: number, b: number): boolean {
    const x = this.items[a]!;
    const y = this.items[b]!;
    return x.amount > y.amount || (x.amount === y.amount && x.member < y.member);
  }

  private swap(a: number, b: number): void {
    [this.items[a], this.items[b]] = [this.items[b]!, this.items[a]!];
  }
}

/** [balances] maps member -> net balance in minor units (positive = is owed money). */
export function simplifyDebts(balances: Map<string, number>): Transfer[] {
  const creditors = new MaxHeap();
  const debtors = new MaxHeap();
  for (const [member, amount] of balances) {
    if (amount > 0) creditors.push({ member, amount });
    else if (amount < 0) debtors.push({ member, amount: -amount });
  }

  const transfers: Transfer[] = [];
  while (creditors.size > 0 && debtors.size > 0) {
    const credit = creditors.pop()!;
    const debt = debtors.pop()!;
    const amount = Math.min(credit.amount, debt.amount);
    transfers.push({ from: debt.member, to: credit.member, amountMinor: amount });

    if (credit.amount > amount) creditors.push({ member: credit.member, amount: credit.amount - amount });
    if (debt.amount > amount) debtors.push({ member: debt.member, amount: debt.amount - amount });
  }
  return transfers;
}

export interface ExpenseLike {
  paidBy: string;
  amountMinor: number;
  shares: Record<string, number>;
}

export interface SettlementLike {
  fromMember: string;
  toMember: string;
  amountMinor: number;
}

/** Net balance per member: what they paid minus what they owe, adjusted by settlements already made. */
export function computeBalances(
  memberIds: string[],
  expenses: ExpenseLike[],
  settlements: SettlementLike[],
): Map<string, number> {
  const balances = new Map<string, number>(memberIds.map((id) => [id, 0]));
  const add = (id: string, delta: number) => balances.set(id, (balances.get(id) ?? 0) + delta);

  for (const expense of expenses) {
    add(expense.paidBy, expense.amountMinor);
    for (const [member, share] of Object.entries(expense.shares)) add(member, -share);
  }
  for (const s of settlements) {
    add(s.fromMember, s.amountMinor);
    add(s.toMember, -s.amountMinor);
  }
  return balances;
}
