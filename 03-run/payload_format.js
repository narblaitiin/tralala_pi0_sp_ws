function decodeUplink(input)
{
    // input payload is an array of bytes (e.g., input.bytes)
    var bytes = input.bytes;

    // check payload length (minimum 14 bytes needed here -> VTH samples)
    if (bytes.length == 12) {
        // decode the int16 values (big-endian representation)
        var pressure = (bytes[0] << 8) | bytes[1];
        if(bytes[2] === 0){
        temperature = ((bytes[3] << 8) | bytes[4])
        } else{
            temperature = ((bytes[3] << 8)| bytes[4]) * -1
        }
        var humidity = (bytes[5] << 8) | bytes[6];
        var luxmen = (bytes[7] << 8) | bytes[8];
        var uvs = (bytes[9] << 8) | bytes[10];
        var gas = (bytes[11] << 8) | bytes[12];     

        // convert to signed 16-bit integers
        if (pressure & 0x8000) pressure -= 0x10000;
        if (temperature & 0x8000) temperature -= 0x10000;
        if (humidity & 0x8000) humidity -= 0x10000;
        if (luxmen & 0x8000) luxmen -= 0x10000;
        if (uvs & 0x8000) uvs -= 0x10000;
        if (gas & 0x8000) gas -= 0x10000;

        // return decoded values as JSON
        return {
            data: {
                Pressure: pressure,
                Temperature: temperature,
                Humidity: humidity,
                Luxem: luxmen,
                UVS: uvs,
                GAS: gas,                     
            },
        }
    }
}
