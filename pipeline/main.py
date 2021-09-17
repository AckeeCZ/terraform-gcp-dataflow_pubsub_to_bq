import argparse
import json
import logging
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions, StandardOptions

# Based on https://medium.com/codex/a-dataflow-journey-from-pubsub-to-bigquery-68eb3270c93

logging.basicConfig(level=logging.INFO)
logging.getLogger().setLevel(logging.INFO)


class CustomParsing(beam.DoFn):
    """ Custom ParallelDo class to apply a custom transformation """

    def to_runner_api_parameter(self, _):
        return "beam:transforms:custom_parsing:custom_v0", None

    def process(self, element: bytes, timestamp=beam.DoFn.TimestampParam, window=beam.DoFn.WindowParam):
        """
        Simple processing function to parse the data and add a timestamp
        For additional params see:
        https://beam.apache.org/releases/pydoc/2.7.0/apache_beam.transforms.core.html#apache_beam.transforms.core.DoFn
        """
        parsed = json.loads(element.decode("utf-8"))
        yield parsed


def run():
    # Parsing arguments
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--input_subscription",
        help='Input PubSub subscription of the form "projects/<PROJECT>/subscriptions/<SUBSCRIPTION>."',
    )
    parser.add_argument(
        "--output_table",
        help="Output BigQuery Table, e.g. PROJECT_ID:DATASET_NAME.TABLE_NAME",
    )
    parser.add_argument(
        "--output_schema",
        help="Output BigQuery Schema in text format, e.g. timestamp:TIMESTAMP,attr1:FLOAT,msg:STRING",
    )
    parser.add_argument(
        "--machine_type",
        help="Machine instance type",
        default="e2-medium",
    )
    parser.add_argument(
        "--disk_size_gb",
        help="Worker disk size",
        default=30,
    )
    parser.add_argument(
        "--max_num_workers",
        help="Maximum count of workers",
        default=1,
    )
    known_args, pipeline_args = parser.parse_known_args()

    # See https://cloud.google.com/dataflow/docs/reference/pipeline-options
    pipeline_options = PipelineOptions(
        pipeline_args,
        runner='DataflowRunner',
        max_num_workers=known_args.max_num_workers,
        num_workers=1,
        disk_size_gb=known_args.disk_size_gb,
        machine_type=known_args.machine_type
    )
    pipeline_options.view_as(StandardOptions).streaming = True

    # Defining our pipeline and its steps
    with beam.Pipeline(
        options=pipeline_options
    ) as p:
        (
            p
            | "ReadFromPubSub" >> beam.io.gcp.pubsub.ReadFromPubSub(
                subscription=known_args.input_subscription, timestamp_attribute=None
            )
            | "CustomParse" >> beam.ParDo(CustomParsing())
            | "WriteToBigQuery" >> beam.io.WriteToBigQuery(
                known_args.output_table,
                schema=known_args.output_schema,
                write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND,
            )
        )


if __name__ == "__main__":
    run()
