<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use App\Models\Url;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

// Route 1: Show the form and the list of all URLs
Route::get('/', function () {
    $urls = Url::latest()->get(); // Fetch existing URLs to display in the list
    return view('welcome', ['urls' => $urls]);
});

// Route 2: Store the new URL and create a short code
Route::post('/shorten', function (Request $request) {
    // 1. Validate the incoming request to ensure it's a valid URL
    $request->validate([
        'original_url' => 'required|url'
    ]);

    // 2. Create a new Url record in the database
    // Note: In a real app, you'd add a check to ensure the generated Str::random(6) is unique.
    $url = Url::create([
        'original_url' => $request->original_url,
        'short_code'   => Str::random(6) 
    ]);

    // 3. Redirect back to the previous page with a success message
    return back()->with('success', 'Short URL Generated!');

})->name('shorten.url');


// Route 3: Redirect from the short code to the original URL (CORRECTED)
Route::get('/{shortcode}', function ($shortcode) {
    $url = Url::where('short_code', $shortcode)->firstOrFail();

    // --- Start of changes ---
    // Manually increment the visit count
    $url->visits++;
    
    // Save the change to the database
    $url->save();
    // --- End of changes ---

    return redirect($url->original_url);
});