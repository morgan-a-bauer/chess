import argparse
import psycopg2
from graphviz import Digraph

def get_tables_and_fks(conn):
    cursor = conn.cursor()
    cursor.execute("""
        SELECT table_name, column_name, data_type
        FROM information_schema.columns
        WHERE table_schema = 'public'
        ORDER BY table_name, ordinal_position;
    """)
    columns = cursor.fetchall()

    cursor.execute("""
        SELECT
            tc.table_name AS source_table,
            kcu.column_name AS source_column,
            ccu.table_name AS target_table,
            ccu.column_name AS target_column
        FROM
            information_schema.table_constraints AS tc
            JOIN information_schema.key_column_usage AS kcu
              ON tc.constraint_name = kcu.constraint_name
            JOIN information_schema.constraint_column_usage AS ccu
              ON ccu.constraint_name = tc.constraint_name
        WHERE
            constraint_type = 'FOREIGN KEY';
    """)
    foreign_keys = cursor.fetchall()
    return columns, foreign_keys

def visualize_schema(columns, foreign_keys, output):
    dot = Digraph(comment='PostgreSQL Schema')
    tables = {}

    for table, column, dtype in columns:
        tables.setdefault(table, []).append(f"{column} : {dtype}")

    for table, cols in tables.items():
        label = f"<<TABLE BORDER='1' CELLBORDER='1' CELLSPACING='0'>"
        label += f"<TR><TD BGCOLOR='lightgray'><B>{table}</B></TD></TR>"
        for col in cols:
            label += f"<TR><TD ALIGN='LEFT'>{col}</TD></TR>"
        label += "</TABLE>>"
        dot.node(table, label=label, shape='plaintext')

    for src_table, src_col, tgt_table, tgt_col in foreign_keys:
        dot.edge(src_table, tgt_table, label=f"{src_col} ➝ {tgt_col}")

    dot.render(output, format='png', cleanup=True)
    print(f"Schema diagram saved as {output}.png")

def main():
    parser = argparse.ArgumentParser(description="Visualize PostgreSQL schema as a graph")
    parser.add_argument('--dbname', required=True, help='Database name')
    parser.add_argument('--user', required=True, help='Database user')
    parser.add_argument('--password', required=True, help='Database password')
    parser.add_argument('--host', default='localhost', help='Database host')
    parser.add_argument('--port', type=int, default=5432, help='Database port')
    parser.add_argument('--output', default='pg_schema', help='Output filename (without extension)')

    args = parser.parse_args()

    conn = psycopg2.connect(
        dbname=args.dbname,
        user=args.user,
        password=args.password,
        host=args.host,
        port=args.port
    )

    columns, foreign_keys = get_tables_and_fks(conn)
    visualize_schema(columns, foreign_keys, args.output)

if __name__ == "__main__":
    main()