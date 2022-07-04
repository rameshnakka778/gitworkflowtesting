import numpy as np
import pandas as pd
from retl_component.aws_s3_service import S3
from retl_component.db_connection import SqlAlchmyEngine
from config.retl_config import RMS_OWNER, JOB_PARAMS, ODATE


def _get_sql_query():
    sql_query_list = [
        f"SELECT a.class class_idnt1, a.dept dept_idnt1, a.class_name class_desc, b.buyer class_buyr_idnt1, b.merch class_mrch_idnt1 FROM {RMS_OWNER}.class a, {RMS_OWNER}.deps b WHERE a.dept = b.dept",
        f"SELECT buyer class_buyr_idnt1, buyer_name class_buyr_name FROM {RMS_OWNER}.buyer",
        f"SELECT merch class_mrch_idnt1, merch_name class_mrch_name FROM {RMS_OWNER}.merchant"]
    
    return sql_query_list

# this is for testing
def extract_prdcls_dimension():
    """
    Script extracts phase dimension information from the RMS channels table
    :return:
    """
    print("============ Job Started ==============")
    engine = SqlAlchmyEngine().get_oracle_engine()

    sql_query = _get_sql_query()

    print("Reading Data from RMS...........")
    class1 = pd.read_sql(sql_query[0], engine)
    class1.columns = [x.upper() for x in class1.columns]
    class1[['CLASS_BUYR_IDNT1', 'CLASS_MRCH_IDNT1', 'CLASS_IDNT1', 'DEPT_IDNT1']] = class1[
        ['CLASS_BUYR_IDNT1', 'CLASS_MRCH_IDNT1', 'CLASS_IDNT1', 'DEPT_IDNT1']].apply(pd.to_numeric)

    buyer = pd.read_sql(sql_query[1], engine)
    buyer.columns = [x.upper() for x in buyer.columns]
    buyer['CLASS_BUYR_IDNT1'] = pd.to_numeric(buyer['CLASS_BUYR_IDNT1'])

    merchant = pd.read_sql(sql_query[2], engine)
    merchant.columns = [x.upper() for x in merchant.columns]
    merchant['CLASS_MRCH_IDNT1'] = pd.to_numeric(merchant['CLASS_MRCH_IDNT1'])

    sort_class1 = class1.sort_values(["CLASS_MRCH_IDNT1"])
    sort_merchant = merchant.sort_values(["CLASS_MRCH_IDNT1"])
    leftouterjoin_class1 = pd.merge(sort_class1, sort_merchant, on="CLASS_MRCH_IDNT1", how="left")
    sort_class2 = leftouterjoin_class1.sort_values(["CLASS_BUYR_IDNT1"])
    sort_buyer = buyer.sort_values(["CLASS_BUYR_IDNT1"])
    leftouterjoin_class2 = pd.merge(sort_class2, sort_buyer, on="CLASS_BUYR_IDNT1", how="left")

    convert_class = leftouterjoin_class2.copy()
    convert_class = convert_class.rename(
        columns={'CLASS_IDNT1': 'CLASS_IDNT', 'DEPT_IDNT1': 'DEPT_IDNT', 'CLASS_BUYR_IDNT1': 'CLASS_BUYR_IDNT',
                 'CLASS_MRCH_IDNT1': 'CLASS_MRCH_IDNT'})
    #convert_class = convert_class.fillna({'CLASS_IDNT': '', 'DEPT_IDNT': '', 'CLASS_BUYR_IDNT': '', 'CLASS_MRCH_IDNT': ''})
    convert_class = convert_class.astype(
        {'CLASS_IDNT': pd.StringDtype(), 'DEPT_IDNT': 'string', 'CLASS_BUYR_IDNT': 'string', 'CLASS_MRCH_IDNT': 'string'})
    #convert_class = convert_class.replace({'nan':None})
    print(convert_class.head(5))

    exit()

    job_params = JOB_PARAMS

    s3_obj = S3(bucket_name=job_params['bucket_name'])
    s3_object_key = s3_obj.get_s3_fileobject_name(
        file_path=job_params['s3_file_path'],
        filename=job_params['s3_filename'],
        file_date=ODATE)

    # load to S3 ucker
    print(f"Loading to S3 Bucket:{job_params['bucket_name']}"
          f" filename:{s3_object_key}")
    resp = s3_obj.upload_df_s3(dataframe=convert_class,
                               object_key=s3_object_key,
                               header_status=False, separator='|',
                               encoding='utf-8', compressed=True)

    print(resp)
    print("==========Job Completed============")

# To call the output function
if __name__ == "__main__":
    extract_prdcls_dimension()
