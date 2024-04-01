# Use rapidsai image for GPU compute
FROM rapidsai/rapidsai:23.06-cuda11.8-runtime-ubuntu22.04-py3.10

RUN apt-get update && apt-get install -y --no-install-recommends

# Set working directory
WORKDIR /notebooks
# Copy Notebooks and data into the container at /notebooks
COPY llm-notebook-with-fine-tune.ipynb .
COPY llm-notebook-with-fine-tune-all-rows.ipynb .
COPY transcripts_base.json .
COPY transcripts_inst.json .
COPY utils.py .

# Install Snowpark Python, Pandas and JupyterLab from Snowflake Anaconda channel
RUN conda install -n rapids -c https://repo.anaconda.com/pkgs/snowflake snowflake-ml-python snowflake-snowpark-python pandas jupyterlab

RUN pip install transformers==4.34.0 tokenizers && \ 
    pip install peft sentencepiece tokenizers vllm==0.2.1.post1 bitsandbytes datasets absl-py==1.3.0 

# Make port 8888 publicly available 
EXPOSE 8888

# Run JupyterLab on port 8888 when the container launches
CMD ["/opt/conda/envs/rapids/bin/jupyter", "llm-spcs", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
