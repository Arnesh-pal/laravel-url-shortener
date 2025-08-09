<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Url extends Model
{
    use HasFactory;
    
    // Allow these fields to be filled via create() method
    protected $fillable = ['original_url', 'short_code'];
}
