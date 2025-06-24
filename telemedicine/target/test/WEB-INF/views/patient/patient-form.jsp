<div class="container my-5">
    <div class="card shadow-lg p-4">
        <h2 class="mb-4">Symptom Input</h2>
        <form action="/submit-symptoms" method="POST">
            <div class="mb-3">
                <label for="symptoms" class="form-label">Describe your symptoms</label>
                <textarea 
                    class="form-control" 
                    id="symptoms" 
                    name="symptoms" 
                    rows="4"
                    placeholder="Enter your symptoms here..."
                ></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Submit</button>
        </form>
    </div>
</div>