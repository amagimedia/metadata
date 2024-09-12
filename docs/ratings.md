# Ratings/Parental Guidance

<div class="no-side-panes">
    <style>
        table {
            border-collapse: collapse;
            border-radius: 5px;
            box-shadow: 0 0 4px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            font-family: "Quicksand", sans-serif;
            font-weight: bold;
            font-size: 14px;
        }

        th {
            background: #009578;
            color: #ffffff;
            text-align: left;
        }

        th,
        td {
        padding: 10px 20px;
        }

        tr:nth-child(even) {
        background: #eeeeee;
        }
    </style>

    <table class="no-side-panes" id="csvRoot"></table>
      
      <script src="https://cdn.jsdelivr.net/npm/papaparse@5.2.0/papaparse.min.js"></script>
      <script src="./table_render.js"></script>
      <script>table_load('./ratings.csv');</script>
</div>