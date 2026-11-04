var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    
    app.UseSwaggerUI(options =>
    {
        options.DocumentTitle = "API Proyecto Intermodular Grupo 2";
        options.SwaggerEndpoint("/openapi/v1.json", "API-PIG2 V1");
    });
}

app.UseHttpsRedirection();
// app.Run();