import { z } from 'zod';

type ColumnKind = 'text' | 'int' | 'json';

export interface Field {
  column: string;
  kind: ColumnKind;
}

export interface EntitySpec {
  /** Name used in the API and the sync protocol. */
  name: EntityName;
  table: string;
  fields: Record<string, Field>;
  /** Validates the entity-specific fields (id/updatedAt/deleted are handled separately). */
  schema: z.ZodObject<z.ZodRawShape>;
}

const id = z.string().min(1).max(64);
const minor = z.number().int().nonnegative();
const epochMs = z.number().int().nonnegative();

const text = (column: string): Field => ({ column, kind: 'text' });
const int = (column: string): Field => ({ column, kind: 'int' });

export const entities = {
  transactions: {
    name: 'transactions',
    table: 'transactions',
    fields: {
      type: text('type'),
      amountMinor: int('amount_minor'),
      currency: text('currency'),
      category: text('category'),
      merchant: text('merchant'),
      note: text('note'),
      occurredAt: int('occurred_at'),
      recurrence: text('recurrence'),
    },
    schema: z.object({
      type: z.enum(['expense', 'income']),
      amountMinor: minor,
      currency: z.string().length(3).default('INR'),
      category: z.string().min(1).max(40),
      merchant: z.string().max(120).nullish(),
      note: z.string().max(500).nullish(),
      occurredAt: epochMs,
      recurrence: z.enum(['none', 'weekly', 'monthly']).default('none'),
    }),
  },
  goals: {
    name: 'goals',
    table: 'goals',
    fields: {
      name: text('name'),
      targetMinor: int('target_minor'),
      savedMinor: int('saved_minor'),
      currency: text('currency'),
      deadline: int('deadline'),
    },
    schema: z.object({
      name: z.string().min(1).max(80),
      targetMinor: z.number().int().positive(),
      savedMinor: minor.default(0),
      currency: z.string().length(3).default('INR'),
      deadline: epochMs,
    }),
  },
  groups: {
    name: 'groups',
    table: 'groups',
    fields: { name: text('name'), currency: text('currency') },
    schema: z.object({
      name: z.string().min(1).max(80),
      currency: z.string().length(3).default('INR'),
    }),
  },
  groupMembers: {
    name: 'groupMembers',
    table: 'group_members',
    fields: { groupId: text('group_id'), name: text('name') },
    schema: z.object({ groupId: id, name: z.string().min(1).max(60) }),
  },
  groupExpenses: {
    name: 'groupExpenses',
    table: 'group_expenses',
    fields: {
      groupId: text('group_id'),
      description: text('description'),
      amountMinor: int('amount_minor'),
      paidBy: text('paid_by'),
      splitType: text('split_type'),
      shares: { column: 'shares', kind: 'json' },
      occurredAt: int('occurred_at'),
    },
    schema: z.object({
      groupId: id,
      description: z.string().min(1).max(120),
      amountMinor: z.number().int().positive(),
      paidBy: id,
      splitType: z.enum(['equal', 'custom']),
      // memberId -> owed amount in minor units. Must add up to amountMinor.
      shares: z.record(id, minor),
      occurredAt: epochMs,
    }),
  },
  settlements: {
    name: 'settlements',
    table: 'settlements',
    fields: {
      groupId: text('group_id'),
      fromMember: text('from_member'),
      toMember: text('to_member'),
      amountMinor: int('amount_minor'),
      occurredAt: int('occurred_at'),
    },
    schema: z.object({
      groupId: id,
      fromMember: id,
      toMember: id,
      amountMinor: z.number().int().positive(),
      occurredAt: epochMs,
    }),
  },
} satisfies Record<string, Omit<EntitySpec, 'name' | 'schema'> & { name: string; schema: z.ZodObject<z.ZodRawShape> }>;

export type EntityName = keyof typeof entities;

export const entityNames = Object.keys(entities) as EntityName[];

export function specFor(name: EntityName): EntitySpec {
  return entities[name] as EntitySpec;
}

export const envelopeSchema = z.object({
  id,
  updatedAt: epochMs,
  deleted: z.boolean().default(false),
});
