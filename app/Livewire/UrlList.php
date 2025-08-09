<?php

namespace App\Livewire;

use App\Models\Url;
use Livewire\Component;

class UrlList extends Component
{
    public function render()
    {
        // This logic fetches the URLs for the component's view.
        $urls = Url::latest()->get();

        return view('livewire.url-list', [
            'urls' => $urls
        ]);
    }
}