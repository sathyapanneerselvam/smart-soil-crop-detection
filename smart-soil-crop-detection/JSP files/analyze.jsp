<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="navbar.jsp" />
<!DOCTYPE html>
<html>
<head>
    <title>Field Partition Analysis</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: url("images/bg.jpg") no-repeat center center fixed;
            background-size: cover;
            margin: 0;
            padding: 0;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 12px;
            width: 700px;
            margin: 40px auto;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.2);
        }

        h2 {
            text-align: center;
            color: green;
            margin-bottom: 25px;
        }

        label, input {
            display: block;
            width: 100%;
            margin-top: 10px;
        }

        input[type="number"], input[type="text"] {
            padding: 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
            margin-bottom: 15px;
        }

        button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: green;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            width: 100%;
        }

        button:hover {
            background-color: darkgreen;
        }

        .partition {
            border: 1px solid #ccc;
            padding: 15px;
            margin-top: 10px;
            border-radius: 8px;
            background: #f9f9f9;
        }

        #partitionFields, #analyzeBtn, #fieldVisualizer {
            display: none;
        }
    </style>

    <script>
        const soilColors = {
            "Red Soil": "#e74c3c",
            "Black Soil": "#2c3e50",
            "Alluvial Soil": "#f1c40f",
            "Laterite Soil": "#d35400",
            "Saline/Alkaline Soil": "#8e44ad",
            "Coastal Sandy Soil": "#f5deb3"
        };

        function generateFields() {
            const num = document.getElementById("partitionCount").value;
            const container = document.getElementById("partitionFields");
            document.getElementById("hiddenPartitionCount").value = num; // 🛠️ Sync hidden input
            container.innerHTML = "";

            if (!num || num < 1 || num > 10) {
                alert("Enter a valid number of partitions (1–10).");
                return;
            }

            for (let i = 1; i <= num; i++) {
                const partitionBlock = document.createElement("div");
                partitionBlock.className = "partition";

                const soilLabel = document.createElement("label");
                soilLabel.setAttribute("for", "soil" + i);
                soilLabel.textContent = "Enter Soil Type for Partition " + i;

                const soilInput = document.createElement("input");
                soilInput.type = "text";
                soilInput.name = "soil" + i;
                soilInput.id = "soil" + i;
                soilInput.placeholder = "e.g. Red Soil";
                soilInput.required = true;
                soilInput.setAttribute("oninput", "updateVisualizer()");

                const cropLabel = document.createElement("label");
                cropLabel.setAttribute("for", "crop" + i);
                cropLabel.textContent = "Enter Crop Name for Partition " + i;

                const cropInput = document.createElement("input");
                cropInput.type = "text";
                cropInput.name = "crop" + i;
                cropInput.id = "crop" + i;
                cropInput.required = true;

                partitionBlock.appendChild(soilLabel);
                partitionBlock.appendChild(soilInput);
                partitionBlock.appendChild(cropLabel);
                partitionBlock.appendChild(cropInput);
                container.appendChild(partitionBlock);
            }

            document.getElementById("partitionFields").style.display = "block";
            document.getElementById("analyzeBtn").style.display = "block";
            document.getElementById("fieldVisualizer").style.display = "block";
            updateVisualizer();
        }

        function updateVisualizer() {
            const count = parseInt(document.getElementById("partitionCount").value);
            const partitionRect = document.getElementById("partitionRect");
            const fieldVisualizer = document.getElementById("fieldVisualizer");

            if (isNaN(count) || count < 1) {
                fieldVisualizer.style.display = "none";
                return;
            }

            partitionRect.innerHTML = "";
            fieldVisualizer.style.display = "block";

            for (let i = 1; i <= count; i++) {
                const soilVal = document.getElementById("soil" + i)?.value.trim();
                const color = soilColors[soilVal] || "#bdc3c7"; // default gray
                const part = document.createElement("div");

                part.style.backgroundColor = color;
                part.style.flex = "1";
                part.style.display = "flex";
                part.style.justifyContent = "center";
                part.style.alignItems = "center";
                part.style.color = "#fff";
                part.style.fontWeight = "bold";
                part.innerText = soilVal || "Partition " + i;

                partitionRect.appendChild(part);
            }
        }
    </script>
</head>
<body>

<div class="container">
    <h2>Analyze Your Field Partitions</h2>

  <form action="analyze" method="post">


        <label for="partitionCount">Number of Partitions:</label>
        <input type="number" name="partitionCount" id="partitionCount" min="1" max="10" required>
        <input type="hidden" name="partitionCount" id="hiddenPartitionCount" /> <!-- 🛠️ This ensures value is submitted -->

        <button type="button" onclick="generateFields()">Generate Partition Fields</button>

        <div id="partitionFields"></div>

        <!-- Visual representation -->
        <div id="fieldVisualizer" style="margin-top: 20px;">
            <h3>Field Partition Visual</h3>
            <div id="partitionRect" style="display: flex; width: 100%; height: 80px; border: 2px solid #000; border-radius: 6px; overflow: hidden;"></div>
        </div>

        <button type="submit" id="analyzeBtn">Analyze</button>
    </form>
</div>

</body>
</html>
