#include "StdAfx.h"
#include "TableFrameSink.h"

//////////////////////////////////////////////////////////////////////////

//��������
#define SEND_COUNT					8									//���ʹ���

//��������
#define INDEX_PLAYER				0									//�м�����
#define INDEX_BANKER				1									//ׯ������

//��עʱ��
#define IDI_PLACE_JETTON			1									//��עʱ��

#ifdef _DEBUG
#define TIME_PLACE_JETTON			30									//��עʱ��
#else
#define TIME_PLACE_JETTON			25									//��עʱ��
#endif

//����ʱ��
#define IDI_GAME_END				2									//����ʱ��
#ifdef _DEBUG
#define TIME_GAME_END				13									//����ʱ��
#else
#define TIME_GAME_END				13									//����ʱ��
#endif

//////////////////////////////////////////////////////////////////////////

//��̬����
const WORD			CTableFrameSink::m_wPlayerCount=GAME_PLAYER;				//��Ϸ����
const enStartMode	CTableFrameSink::m_GameStartMode=enStartMode_TimeControl;	//��ʼģʽ

//////////////////////////////////////////////////////////////////////////

//����ṹ
struct tagReplaceCard
{
	BYTE							cbCardCount[2];						//�˿���Ŀ
    BYTE							cbTableCardArray[2][3];				//�����˿�
};

//ƽ�Ҵ���
tagReplaceCard CardTieWinCard[]=
{
	3,3,0x12,0x05,0x00,0x22,0x25,0x32,
	3,3,0x11,0x05,0x00,0x14,0x2B,0x32,
	3,3,0x1A,0x2B,0x3D,0x1C,0x3C,0x0B,
	3,3,0x27,0x2D,0x00,0x01,0x39,0x3D,
	3,3,0x3C,0x28,0x00,0x12,0x15,0x01,
};

//ׯ�Ҵ���
tagReplaceCard CardBankerWinCard[]=
{
	3,3,0x17,0x1A,0x05,0x36,0x0D,0x1C,
	3,3,0x17,0x03,0x3A,0x1C,0x1A,0x34,
	3,3,0x11,0x0D,0x1D,0x35,0x32,0x00,
	3,3,0x18,0x29,0x00,0x22,0x16,0x00,
	3,3,0x38,0x1A,0x00,0x25,0x04,0x00,
};

//�мҴ���
tagReplaceCard CardPlayerWinCard[]=
{
	3,3,0x37,0x3D,0x00,0x31,0x3D,0x0D,
	3,3,0x16,0x24,0x08,0x03,0x3D,0x00,
	3,3,0x0B,0x39,0x00,0x09,0x35,0x00,
	3,3,0x2C,0x08,0x00,0x02,0x15,0x00,
	3,3,0x16,0x33,0x00,0x1A,0x27,0x00,
};

//////////////////////////////////////////////////////////////////////////

//���캯��
CTableFrameSink::CTableFrameSink()
{
	//��ע��Ϣ
	m_lTieScore=0L;
	m_lBankerScore=0L;
	m_lPlayerScore=0L;
	m_lTieSamePointScore=0L;
	m_lBankerKingScore=0L;
	m_lPlayerKingScore=0L;


	//������
	m_lStockScore=0;
	m_lDesPer = 0 ;

	m_lFreezeScore=0L;

	//״̬����
	m_dwJettonTime=0L;

	//��ע��Ϣ
	ZeroMemory(m_lUserTieScore,sizeof(m_lUserTieScore));
	ZeroMemory(m_lUserBankerScore,sizeof(m_lUserBankerScore));
	ZeroMemory(m_lUserPlayerScore,sizeof(m_lUserPlayerScore));
	ZeroMemory(m_lUserTieSamePointScore,sizeof(m_lUserTieSamePointScore));
	ZeroMemory(m_lUserBankerKingScore,sizeof(m_lUserBankerKingScore));
	ZeroMemory(m_lUserPlayerKingScore,sizeof(m_lUserPlayerKingScore));

	//��ҳɼ�
	ZeroMemory(m_lUserWinScore, sizeof(m_lUserWinScore));
	ZeroMemory(m_lUserReturnScore, sizeof(m_lUserReturnScore));
	ZeroMemory(m_lUserRevenue, sizeof(m_lUserRevenue));

	//�˿���Ϣ
	ZeroMemory(m_cbCardCount,sizeof(m_cbCardCount));
	ZeroMemory(m_cbTableCardArray,sizeof(m_cbTableCardArray));

	//ׯ�ұ���
	m_lApplyBankerCondition = 100000000;
	ZeroMemory( &m_CurrentBanker, sizeof( m_CurrentBanker ) );
	m_cbBankerTimer=0;
	m_lBankerWinScore = 0;
	m_bCancelBanker=false;
	
	//�������
	m_pITableFrame=NULL;
	m_pGameServiceOption=NULL;
	m_pITableFrameControl=NULL;

	//��Ϸ��¼
	ZeroMemory(m_GameRecordArrary, sizeof(m_GameRecordArrary));
	m_nRecordFirst=0;	
	m_nRecordLast=0;	


	//��ȡ����
	TCHAR szPath[MAX_PATH]=TEXT("");
	GetCurrentDirectory(sizeof(szPath),szPath);

	//��ȡ����
	TCHAR szFileName[MAX_PATH];
	_snprintf(szFileName,sizeof(szFileName),TEXT("%s\\BaccaratConfig.ini"),szPath);

	//��ȡ����
	m_lApplyBankerCondition = GetPrivateProfileInt( TEXT("BankerCondition"), TEXT("Score"), 10000000, szFileName );
	m_lAreaLimitScore = GetPrivateProfileInt( TEXT("BankerCondition"), TEXT("AreaLimitScore"), 1000000000, szFileName );

	return;
}

//��������
CTableFrameSink::~CTableFrameSink(void)
{
}

//�ӿڲ�ѯ
void * __cdecl CTableFrameSink::QueryInterface(const IID & Guid, DWORD dwQueryVer)
{
	QUERYINTERFACE(ITableFrameSink,Guid,dwQueryVer);
	QUERYINTERFACE(ITableUserAction,Guid,dwQueryVer);
	QUERYINTERFACE_IUNKNOWNEX(ITableFrameSink,Guid,dwQueryVer);
	return NULL;
}

//��ʼ��
bool __cdecl CTableFrameSink::InitTableFrameSink(IUnknownEx * pIUnknownEx)
{
	//��ѯ�ӿ�
	ASSERT(pIUnknownEx!=NULL);
	m_pITableFrame=QUERY_OBJECT_PTR_INTERFACE(pIUnknownEx,ITableFrame);
	if (m_pITableFrame==NULL) return false;

	//���ƽӿ�
	m_pITableFrameControl=QUERY_OBJECT_PTR_INTERFACE(pIUnknownEx,ITableFrameControl);
	if (m_pITableFrameControl==NULL) return false;

	//��ȡ����
	m_pGameServiceOption=m_pITableFrame->GetGameServiceOption();
	ASSERT(m_pGameServiceOption!=NULL);

	//���ò���
	TCHAR   buffer[MAX_PATH];
	if (GetCurrentDirectory(sizeof(buffer), buffer))
	{
		CString strIniFileName ;

		CString szDir = buffer;
		if(szDir.Right(1) != "\\")	szDir += "\\";
		szDir += "BaccaratConfig.ini";
		strIniFileName= szDir ;

		if(!strIniFileName.IsEmpty())
		{
            //�����Ŀ
			CString StockScore ;
			GetPrivateProfileString(TEXT("StockScore"), TEXT("StockScore"), NULL, StockScore.GetBuffer(64), 64, strIniFileName) ;
			StockScore.ReleaseBuffer() ;
			m_lStockScore = atol(LPCTSTR(StockScore)) ;

			//�ݼ�����
			CString DesPer ;
			GetPrivateProfileString(TEXT("DesPer"), TEXT("DesPer"), NULL, DesPer.GetBuffer(64), 64, strIniFileName) ;
			DesPer.ReleaseBuffer() ;
			m_lDesPer = atol(LPCTSTR(DesPer)) ;
		}

		if(m_lDesPer<=0) m_lDesPer = 2 ;
		if(m_lStockScore<=0) m_lStockScore = 5000 ;

	}

	return true;
}

//��λ����
void __cdecl CTableFrameSink::RepositTableFrameSink()
{
	//��ע��Ϣ
	m_lTieScore=0L;
	m_lBankerScore=0L;
	m_lPlayerScore=0L;
	m_lTieSamePointScore=0L;
	m_lBankerKingScore=0L;
	m_lPlayerKingScore=0L;

	//��ע��Ϣ
	ZeroMemory(m_lUserTieScore,sizeof(m_lUserTieScore));
	ZeroMemory(m_lUserBankerScore,sizeof(m_lUserBankerScore));
	ZeroMemory(m_lUserPlayerScore,sizeof(m_lUserPlayerScore));
	ZeroMemory(m_lUserTieSamePointScore,sizeof(m_lUserTieSamePointScore));
	ZeroMemory(m_lUserBankerKingScore,sizeof(m_lUserBankerKingScore));
	ZeroMemory(m_lUserPlayerKingScore,sizeof(m_lUserPlayerKingScore));

	//�˿���Ϣ
	ZeroMemory(m_cbCardCount,sizeof(m_cbCardCount));
	ZeroMemory(m_cbTableCardArray,sizeof(m_cbTableCardArray));

	//��ҳɼ�
	ZeroMemory(m_lUserWinScore, sizeof(m_lUserWinScore));
	ZeroMemory(m_lUserReturnScore, sizeof(m_lUserReturnScore));
	ZeroMemory(m_lUserRevenue, sizeof(m_lUserRevenue));

	return;
}

//��ʼģʽ
enStartMode __cdecl CTableFrameSink::GetGameStartMode()
{
	return m_GameStartMode;
}

//��Ϸ״̬
bool __cdecl CTableFrameSink::IsUserPlaying(WORD wChairID)
{
	return true;
}

//��Ϸ��ʼ
bool __cdecl CTableFrameSink::OnEventGameStart()
{
	//����״̬
	m_pITableFrame->SetGameStatus(GS_PLAYING);

	//�����˿�
	DispatchTableCard();

	//��������
	CMD_S_GameStart GameStart;
	ZeroMemory(&GameStart,sizeof(GameStart));

	//��������
	CopyMemory(GameStart.cbCardCount,m_cbCardCount,sizeof(m_cbCardCount));
	CopyMemory(GameStart.cbTableCardArray,m_cbTableCardArray,sizeof(m_cbTableCardArray));
	GameStart.lApplyBankerCondition = m_lApplyBankerCondition;

	//��������
	m_pITableFrame->SendTableData(INVALID_CHAIR,SUB_S_GAME_START,&GameStart,sizeof(GameStart));
	m_pITableFrame->SendLookonData(INVALID_CHAIR,SUB_S_GAME_START,&GameStart,sizeof(GameStart));

	//�������
	CalculateScore();

	return true;
}

//��Ϸ����
bool __cdecl CTableFrameSink::OnEventGameEnd(WORD wChairID, IServerUserItem * pIServerUserItem, BYTE cbReason)
{
	switch (cbReason)
	{
	case GER_NORMAL:		//�������
		{
			//������Ϣ
			CMD_S_GameEnd GameEnd;
			ZeroMemory(&GameEnd,sizeof(GameEnd));

			GameEnd.nBankerTime = m_cbBankerTimer;

			GameEnd.lBankerTotalScore = m_lBankerWinScore;

			//�ƶ����
			DeduceWinner(GameEnd.cbWinner, GameEnd.cbKingWinner);			

			//д�����
			for ( WORD wUserChairID = 0; wUserChairID < GAME_PLAYER; ++wUserChairID )
			{
				IServerUserItem *pIServerUserItem = m_pITableFrame->GetServerUserItem(wUserChairID);
				if ( pIServerUserItem == NULL ) continue;

				//ʤ������
				enScoreKind ScoreKind=(m_lUserWinScore[wUserChairID]>0L)?enScoreKind_Win:enScoreKind_Lost;

				//д�����
				if (m_lUserWinScore[wUserChairID]!=0L) m_pITableFrame->WriteUserScore(wUserChairID,m_lUserWinScore[wUserChairID], m_lUserRevenue[wUserChairID], ScoreKind);

				//ׯ���ж�
				if ( m_CurrentBanker.dwUserID == pIServerUserItem->GetUserID() ) m_CurrentBanker.lUserScore = pIServerUserItem->GetUserScore()->lScore;
			}

			//���ͻ���
			GameEnd.cbTimeLeave=TIME_PLACE_JETTON;	
			if ( m_CurrentBanker.dwUserID != 0 ) GameEnd.lBankerTreasure = m_CurrentBanker.lUserScore;
			for ( WORD wUserIndex = 0; wUserIndex < GAME_PLAYER; ++wUserIndex )
			{
				IServerUserItem *pIServerUserItem = m_pITableFrame->GetServerUserItem(wUserIndex);
				if ( pIServerUserItem == NULL ) continue;

				//������Ϣ					
				GameEnd.lMeMaxScore=pIServerUserItem->GetUserScore()->lScore;
				m_pITableFrame->SendTableData(wUserIndex,SUB_S_GAME_END,&GameEnd,sizeof(GameEnd));
				m_pITableFrame->SendLookonData(wUserIndex,SUB_S_GAME_END,&GameEnd,sizeof(GameEnd));
			}

			//ׯ���ж�
			if ( m_CurrentBanker.dwUserID != 0 )
			{
				//��ȡ�û�
				IServerUserItem * pIServerUserItem=m_pITableFrame->GetServerUserItem(m_CurrentBanker.wChairID);
				if (pIServerUserItem) 
				{
					//�����ж�
					if ( pIServerUserItem->GetUserScore()->lScore < m_lApplyBankerCondition )
					{
						//�����ׯ
						OnUserApplyBanker( pIServerUserItem->GetUserData(), false );
					}
				}
			}

			//������Ϸ
			m_pITableFrame->ConcludeGame();

			return true;
		}
	case GER_USER_LEFT:		//�û��뿪
		{
			//ʤ������
			enScoreKind ScoreKind=(m_lUserWinScore[wChairID]>0L)?enScoreKind_Win:enScoreKind_Lost;

			//д�����
			if (m_lUserWinScore[wChairID]!=0L) m_pITableFrame->WriteUserScore(wChairID,m_lUserWinScore[wChairID], m_lUserRevenue[wChairID], ScoreKind);

			return true;
		}
	}

	return false;
}

//���ͳ���
bool __cdecl CTableFrameSink::SendGameScene(WORD wChiarID, IServerUserItem * pIServerUserItem, BYTE cbGameStatus, bool bSendSecret)
{
	switch (cbGameStatus)
	{
	case GS_FREE:			//����״̬
		{
			//���ͼ�¼
			WORD wBufferSize=0;
			BYTE cbBuffer[4096];
			int nIndex = m_nRecordFirst;
			while ( nIndex != m_nRecordLast )
			{
				if ((wBufferSize+sizeof(tagServerGameRecord))>sizeof(cbBuffer))
				{
					m_pITableFrame->SendUserData(pIServerUserItem,SUB_S_SEND_RECORD,cbBuffer,wBufferSize);
					wBufferSize=0;
				}
				CopyMemory(cbBuffer+wBufferSize,&m_GameRecordArrary[nIndex],sizeof(tagServerGameRecord));
				wBufferSize+=sizeof(tagServerGameRecord);

				nIndex = (nIndex+1) % MAX_SCORE_HISTORY;
			}
			if (wBufferSize>0) m_pITableFrame->SendUserData(pIServerUserItem,SUB_S_SEND_RECORD,cbBuffer,wBufferSize);

			//��������
			CMD_S_StatusFree StatusFree;
			ZeroMemory(&StatusFree,sizeof(StatusFree));

			//��ע��Ϣ
			StatusFree.lTieScore=m_lTieScore;
			StatusFree.lBankerScore=m_lBankerScore;
			StatusFree.lPlayerScore=m_lPlayerScore;
			StatusFree.lTieSamePointScore = m_lTieSamePointScore;
			StatusFree.lBankerKingScore = m_lBankerKingScore;
			StatusFree.lPlayerKingScore = m_lPlayerKingScore;

			StatusFree.lAreaLimitScore = m_lAreaLimitScore;

			//ׯ����Ϣ
			StatusFree.lApplyBankerCondition = m_lApplyBankerCondition;

			//��ע��Ϣ
			if (pIServerUserItem->GetUserStatus()!=US_LOOKON)
			{
				StatusFree.lMeTieScore=m_lUserTieScore[wChiarID];
				StatusFree.lMeBankerScore=m_lUserBankerScore[wChiarID];
				StatusFree.lMePlayerScore=m_lUserPlayerScore[wChiarID];
				StatusFree.lMeTieKingScore = m_lUserTieSamePointScore[wChiarID];
				StatusFree.lMeBankerKingScore = m_lUserBankerKingScore[wChiarID];
				StatusFree.lMePlayerKingScore = m_lUserPlayerKingScore[wChiarID];
				StatusFree.lMeMaxScore=pIServerUserItem->GetUserScore()->lScore;
			}
	
			if ( m_CurrentBanker.dwUserID != 0 ) 
			{
				StatusFree.cbBankerTime = m_cbBankerTimer;
				StatusFree.lCurrentBankerScore = m_lBankerWinScore;
				StatusFree.wCurrentBankerChairID = m_CurrentBanker.wChairID;
				StatusFree.lBankerTreasure = m_CurrentBanker.lUserScore;
			}
			else StatusFree.wCurrentBankerChairID = INVALID_CHAIR;
			

			//ȫ����Ϣ
			DWORD dwPassTime=(DWORD)time(NULL)-m_dwJettonTime;
			StatusFree.cbTimeLeave=(BYTE)(TIME_PLACE_JETTON-__min(dwPassTime,TIME_PLACE_JETTON));

			//���ͳ���
			bool bSuccess = m_pITableFrame->SendGameScene(pIServerUserItem,&StatusFree,sizeof(StatusFree));
			
			//����������
			SendApplyUser(  pIServerUserItem );

			return bSuccess;
		}
	case GS_PLAYING:		//��Ϸ״̬
		{
			//��������
			CMD_S_StatusPlay StatusPlay;
			ZeroMemory(&StatusPlay,sizeof(StatusPlay));

			//��ע��Ϣ
			StatusPlay.lTieScore=m_lTieScore;
			StatusPlay.lBankerScore=m_lBankerScore;
			StatusPlay.lPlayerScore=m_lPlayerScore;
			StatusPlay.lTieSamePointScore = m_lTieSamePointScore;
			StatusPlay.lBankerKingScore = m_lBankerKingScore;
			StatusPlay.lPlayerKingScore = m_lPlayerKingScore;

			StatusPlay.lAreaLimitScore = m_lAreaLimitScore;

			//ׯ����Ϣ
			StatusPlay.lApplyBankerCondition = m_lApplyBankerCondition;

			//��ע��Ϣ
			if (pIServerUserItem->GetUserStatus()!=US_LOOKON)
			{
				StatusPlay.lMeTieScore=m_lUserTieScore[wChiarID];
				StatusPlay.lMeBankerScore=m_lUserBankerScore[wChiarID];
				StatusPlay.lMePlayerScore=m_lUserPlayerScore[wChiarID];
				StatusPlay.lMeTieKingScore = m_lUserTieSamePointScore[wChiarID];
				StatusPlay.lMeBankerKingScore = m_lUserBankerKingScore[wChiarID];
				StatusPlay.lMePlayerKingScore = m_lUserPlayerKingScore[wChiarID];
				StatusPlay.lMeMaxScore=pIServerUserItem->GetUserScore()->lScore;
			}

			if ( m_CurrentBanker.dwUserID != 0 ) 
			{
				StatusPlay.cbBankerTime = m_cbBankerTimer;
				StatusPlay.lCurrentBankerScore = m_lBankerWinScore;
				StatusPlay.wCurrentBankerChairID = m_CurrentBanker.wChairID;
				StatusPlay.lBankerTreasure = m_CurrentBanker.lUserScore;
			}
			else StatusPlay.wCurrentBankerChairID = INVALID_CHAIR;

			//�˿���Ϣ
			CopyMemory(StatusPlay.cbCardCount,m_cbCardCount,sizeof(m_cbCardCount));
			CopyMemory(StatusPlay.cbTableCardArray,m_cbTableCardArray,sizeof(m_cbTableCardArray));

			//����������
			SendApplyUser( pIServerUserItem );

			//���ͳ���
			return m_pITableFrame->SendGameScene(pIServerUserItem,&StatusPlay,sizeof(StatusPlay));
		}
	}

	return false;
}

//��ʱ���¼�
bool __cdecl CTableFrameSink::OnTimerMessage(WORD wTimerID, WPARAM wBindParam)
{
	switch (wTimerID)
	{
	case IDI_PLACE_JETTON:		//��עʱ��
		{
			//��������
			LONGLONG lIncrease=LONGLONG(m_lStockScore*m_lDesPer/100.);

			//���ÿ��
			if (m_lTieScore+m_lBankerScore+m_lPlayerScore)
			{
				m_lStockScore-=lIncrease;
				m_lFreezeScore+=lIncrease;
			}

			//��ʼ��Ϸ
			m_pITableFrameControl->StartGame();

			//����ʱ��
			m_pITableFrame->SetGameTimer(IDI_GAME_END,TIME_GAME_END*1000,1,0L);

			return true;
		}
	case IDI_GAME_END:			//������Ϸ
		{
			//������Ϸ
			OnEventGameEnd(INVALID_CHAIR,NULL,GER_NORMAL);

			//��ׯ�ж�
			if ( m_bCancelBanker && m_CurrentBanker.dwUserID != 0 )
			{		
				//��ȡ���
				IServerUserItem *pServerUserItem = m_pITableFrame->GetServerUserItem( m_CurrentBanker.wChairID );

				//���ñ���
				m_cbBankerTimer = 0;
				m_lBankerWinScore=0;
				ZeroMemory( &m_CurrentBanker, sizeof( m_CurrentBanker ) );
				m_bCancelBanker=false;
				
				//������Ϣ
				SendChangeBankerMsg();

				//ɾ��ׯ��
				if ( pServerUserItem ) OnUserApplyBanker( pServerUserItem->GetUserData(), false );
			}

			//����ʱ��
			m_dwJettonTime=(DWORD)time(NULL);
			m_pITableFrame->SetGameTimer(IDI_PLACE_JETTON,TIME_PLACE_JETTON*1000,1,0L);

			//�ֻ�ׯ��
			ChangeBanker();

			//ׯ����Ϣ
			if ( m_CurrentBanker.dwUserID != 0 )
			{
				CMD_S_ChangeUserScore ChangeUserScore;
				ZeroMemory( &ChangeUserScore, sizeof( ChangeUserScore ) );
				ChangeUserScore.wCurrentBankerChairID = m_CurrentBanker.wChairID;
				ChangeUserScore.lCurrentBankerScore = m_lBankerWinScore;
				ChangeUserScore.cbBankerTime = m_cbBankerTimer;
				ChangeUserScore.lScore = m_CurrentBanker.lUserScore;
				ChangeUserScore.wChairID = m_CurrentBanker.wChairID;
				m_pITableFrame->SendTableData( INVALID_CHAIR,SUB_S_CHANGE_USER_SCORE,&ChangeUserScore,sizeof(ChangeUserScore));
				m_pITableFrame->SendLookonData( INVALID_CHAIR,SUB_S_CHANGE_USER_SCORE,&ChangeUserScore,sizeof(ChangeUserScore));
			}

			//�л��ж�
			if ( m_cbBankerTimer == 0 )
			{
				//������Ϣ
				SendChangeBankerMsg();
			}

			return true;
		}
	}

	return false;
}

//��Ϸ��Ϣ����
bool __cdecl CTableFrameSink::OnGameMessage(WORD wSubCmdID, const void * pDataBuffer, WORD wDataSize, IServerUserItem * pIServerUserItem)
{
	switch (wSubCmdID)
	{
	case SUB_C_PLACE_JETTON:		//�û���ע
		{
			//Ч������
			ASSERT(wDataSize==sizeof(CMD_C_PlaceJetton));
			if (wDataSize!=sizeof(CMD_C_PlaceJetton)) return false;

			//�û�Ч��
			tagServerUserData * pUserData=pIServerUserItem->GetUserData();
			if (pUserData->cbUserStatus!=US_SIT) return true;

			//��Ϣ����
			CMD_C_PlaceJetton * pPlaceJetton=(CMD_C_PlaceJetton *)pDataBuffer;
			return OnUserPlaceJetton(pUserData->wChairID,pPlaceJetton->cbJettonArea,pPlaceJetton->lJettonScore);
		}
	case SUB_C_APPLY_BANKER:		//������ׯ
		{
			//Ч������
			ASSERT(wDataSize==sizeof(CMD_C_ApplyBanker));
			if (wDataSize!=sizeof(CMD_C_ApplyBanker)) return false;

			//�û�Ч��
			tagServerUserData * pUserData=pIServerUserItem->GetUserData();
			if (pUserData->cbUserStatus!=US_SIT) return true;

			//��Ϣ����
			CMD_C_ApplyBanker * pApplyBanker=(CMD_C_ApplyBanker *)pDataBuffer;

			return OnUserApplyBanker( pUserData, pApplyBanker->bApplyBanker );	
		}
	}

	return false;
}

//�����Ϣ����
bool __cdecl CTableFrameSink::OnFrameMessage(WORD wSubCmdID, const void * pDataBuffer, WORD wDataSize, IServerUserItem * pIServerUserItem)
{
	return false;
}

//�û�����
bool __cdecl CTableFrameSink::OnActionUserSitDown(WORD wChairID, IServerUserItem * pIServerUserItem, bool bLookonUser)
{
	//����ʱ��
	if ((bLookonUser==false)&&(m_dwJettonTime==0L))
	{
		m_dwJettonTime=(DWORD)time(NULL);
		m_pITableFrame->SetGameTimer(IDI_PLACE_JETTON,TIME_PLACE_JETTON,1,NULL);
	}

	return true;
}

//�û�����
bool __cdecl CTableFrameSink::OnActionUserStandUp(WORD wChairID, IServerUserItem * pIServerUserItem, bool bLookonUser)
{
	//��¼�ɼ�
	if (bLookonUser==false)
	{
		//״̬�ж�
		if ( m_pITableFrame->GetGameStatus() != GS_PLAYING )
		{
			//��������
			LONG lScore=0;
			LONG lRevenue=0;
			enScoreKind ScoreKind;

			//���ͳ��
			m_lStockScore+=( m_lUserTieScore[wChairID] + m_lUserBankerScore[wChairID] + m_lUserPlayerScore[wChairID] + 
				m_lUserBankerKingScore[wChairID] + m_lUserPlayerKingScore[wChairID] + m_lUserTieSamePointScore[wChairID]);

			//ͳ�Ƴɼ�
			lScore=-( m_lUserTieScore[wChairID] + m_lUserBankerScore[wChairID] + m_lUserPlayerScore[wChairID] + 
				m_lUserBankerKingScore[wChairID] + m_lUserPlayerKingScore[wChairID] + m_lUserTieSamePointScore[wChairID]);

			//�������
			m_lUserTieScore[wChairID] = 0; 
			m_lUserBankerScore[wChairID] = 0;
			m_lUserPlayerScore[wChairID] = 0;
			m_lUserBankerKingScore[wChairID] = 0 ;
			m_lUserPlayerKingScore[wChairID] = 0;
			m_lUserTieSamePointScore[wChairID] = 0;

			//д�����
			if (lScore!=0L)
			{
				//д�����
				ScoreKind=enScoreKind_Flee;
				m_pITableFrame->WriteUserScore(pIServerUserItem, lScore,lRevenue, ScoreKind);
			}
		}

		//�����ж�
		for ( INT_PTR nUserIdx = 0; nUserIdx < m_ApplyUserArrary.GetCount(); ++nUserIdx )
		{
			tagApplyUserInfo ApplyUserInfo = m_ApplyUserArrary[ nUserIdx ];

			if ( ApplyUserInfo.dwUserID == pIServerUserItem->GetUserID() )
			{
				//ɾ�����
				m_ApplyUserArrary.RemoveAt( nUserIdx );

				//�������
				CMD_S_ApplyBanker ApplyBanker;
				CopyMemory( ApplyBanker.szAccount, pIServerUserItem->GetAccounts(), sizeof( ApplyBanker.szAccount ) );
				ApplyBanker.lScore = pIServerUserItem->GetUserScore()->lScore;
				ApplyBanker.bApplyBanker = false;

				//������Ϣ
				m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_APPLY_BANKER, &ApplyBanker, sizeof( ApplyBanker ) );
				m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_APPLY_BANKER, &ApplyBanker, sizeof( ApplyBanker ) );

				//��ǰ�ж�
				if ( ApplyUserInfo.dwUserID == m_CurrentBanker.dwUserID )
				{
					//���ñ���
					ZeroMemory( &m_CurrentBanker, sizeof( m_CurrentBanker ) );
					m_cbBankerTimer=0;
					m_lBankerWinScore=0;

					//������Ϣ
					SendChangeBankerMsg();
				}

			}
		}
	}

	return true;
}

//��ע�¼�
bool CTableFrameSink::OnUserPlaceJetton(WORD wChairID, BYTE cbJettonArea, LONG lJettonScore)
{
	//Ч�����
	ASSERT((cbJettonArea<=ID_TONG_DIAN_PING)&&(lJettonScore>0L));
	if ((cbJettonArea>ID_TONG_DIAN_PING)||(lJettonScore<=0L)) return false;

	//Ч��״̬
	ASSERT(m_pITableFrame->GetGameStatus()==GS_FREE);
	if (m_pITableFrame->GetGameStatus()!=GS_FREE) return true;

	//ׯ���ж�
	if ( m_CurrentBanker.dwUserID != 0 && m_CurrentBanker.wChairID == wChairID ) return true;
	if ( m_CurrentBanker.dwUserID == 0 ) return true;

	//��������
	IServerUserItem * pIServerUserItem=m_pITableFrame->GetServerUserItem(wChairID);
	LONG lJettonCount=m_lUserTieScore[wChairID]+m_lUserBankerScore[wChairID]+m_lUserPlayerScore[wChairID]+
		m_lUserTieSamePointScore[wChairID] + m_lUserPlayerKingScore[wChairID] + m_lUserBankerKingScore[wChairID];

	LONG lUserScore = pIServerUserItem->GetUserScore()->lScore;

	if ( lUserScore < lJettonCount + lJettonScore ) return true;

	//�Ϸ���֤
	if ( ID_XIAN_JIA == cbJettonArea )
	{
		if ( GetMaxPlayerScore(wChairID) < lJettonScore ) return true;

		//������ע
		m_lPlayerScore += lJettonScore;
		m_lUserPlayerScore[wChairID] += lJettonScore;
	}
	else if ( ID_XIAN_TIAN_WANG == cbJettonArea )
	{
		if ( GetMaxPlayerKingScore(wChairID) <lJettonScore ) return true;

		//������ע
		m_lPlayerKingScore += lJettonScore;
		m_lUserPlayerKingScore[wChairID] += lJettonScore;
	}
	else if ( ID_PING_JIA == cbJettonArea )
	{
		if ( GetMaxTieScore(wChairID) <lJettonScore ) return true;

		//������ע
		m_lTieScore += lJettonScore;
		m_lUserTieScore[wChairID] += lJettonScore;
	}
	else if ( ID_TONG_DIAN_PING == cbJettonArea )
	{
		if ( GetMaxTieKingScore(wChairID) <lJettonScore ) return true;

		//������ע
		m_lTieSamePointScore += lJettonScore;
		m_lUserTieSamePointScore[wChairID] += lJettonScore;
	}
	else if ( ID_ZHUANG_JIA == cbJettonArea )
	{
		if ( GetMaxBankerScore(wChairID) <lJettonScore ) return true;

		//������ע
		m_lBankerScore += lJettonScore;
		m_lUserBankerScore[wChairID] += lJettonScore;
	}
	else if ( ID_ZHUANG_TIAN_WANG == cbJettonArea )
	{
		if ( GetMaxBankerKingScore(wChairID) <lJettonScore ) return true;

		//������ע
		m_lBankerKingScore += lJettonScore;
		m_lUserBankerKingScore[wChairID] += lJettonScore;
	}
	else
	{
		ASSERT(FALSE);
		return true;
	}

	//��������
	CMD_S_PlaceJetton PlaceJetton;
	ZeroMemory(&PlaceJetton,sizeof(PlaceJetton));

	//�������
	PlaceJetton.wChairID=wChairID;
	PlaceJetton.cbJettonArea=cbJettonArea;
	PlaceJetton.lJettonScore=lJettonScore;

	//������Ϣ
	m_pITableFrame->SendTableData(INVALID_CHAIR,SUB_S_PLACE_JETTON,&PlaceJetton,sizeof(PlaceJetton));
	m_pITableFrame->SendLookonData(INVALID_CHAIR,SUB_S_PLACE_JETTON,&PlaceJetton,sizeof(PlaceJetton));

	return true;
}

//�����˿�
bool CTableFrameSink::DispatchTableCard()
{
//#ifdef _DEBUG
//	//ƽ��ʤ��
//	BYTE cbIndex=0;
//	CopyMemory(m_cbCardCount,CardTieWinCard[cbIndex].cbCardCount,sizeof(m_cbCardCount));
//	CopyMemory(m_cbTableCardArray,CardTieWinCard[cbIndex].cbTableCardArray,sizeof(m_cbTableCardArray));
//#else
//	m_GameLogic.RandCardList(m_cbTableCardArray[0],sizeof(m_cbTableCardArray)/sizeof(m_cbTableCardArray[0][0]));
//#endif

	m_GameLogic.RandCardList(m_cbTableCardArray[0],sizeof(m_cbTableCardArray)/sizeof(m_cbTableCardArray[0][0]));
	//�״η���
	m_cbCardCount[INDEX_PLAYER]=2;
	m_cbCardCount[INDEX_BANKER]=2;
	

	//�������
	BYTE cbBankerCount=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_BANKER],m_cbCardCount[INDEX_BANKER]);
	BYTE cbPlayerTwoCardCount = m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_PLAYER],m_cbCardCount[INDEX_PLAYER]);

	//�мҲ���
	BYTE cbPlayerThirdCardValue = 0 ;	//�������Ƶ���
	if(cbPlayerTwoCardCount<=5 && cbBankerCount<8)
	{
		//�������
		m_cbCardCount[INDEX_PLAYER]++;
		cbPlayerThirdCardValue = m_GameLogic.GetCardPip(m_cbTableCardArray[INDEX_PLAYER][2]);
	}

	//ׯ�Ҳ���
	if(cbPlayerTwoCardCount<8 && cbBankerCount<8)
	{
		switch(cbBankerCount)
		{
		case 0:
		case 1:
		case 2:
			m_cbCardCount[INDEX_BANKER]++ ;
			break;

		case 3:
			if((m_cbCardCount[INDEX_PLAYER]==3 && cbPlayerThirdCardValue!=8) || m_cbCardCount[INDEX_PLAYER]==2) m_cbCardCount[INDEX_BANKER]++ ;
			break;

		case 4:
			if((m_cbCardCount[INDEX_PLAYER]==3 && cbPlayerThirdCardValue!=1 && cbPlayerThirdCardValue!=8 && cbPlayerThirdCardValue!=9 && cbPlayerThirdCardValue!=0) || m_cbCardCount[INDEX_PLAYER]==2) m_cbCardCount[INDEX_BANKER]++ ;
			break;

		case 5:
			if((m_cbCardCount[INDEX_PLAYER]==3 && cbPlayerThirdCardValue!=1 && cbPlayerThirdCardValue!=2 && cbPlayerThirdCardValue!=3  && cbPlayerThirdCardValue!=8 && cbPlayerThirdCardValue!=9 &&  cbPlayerThirdCardValue!=0) || m_cbCardCount[INDEX_PLAYER]==2) m_cbCardCount[INDEX_BANKER]++ ;
			break;

		case 6:
			if(m_cbCardCount[INDEX_PLAYER]==3 && (cbPlayerThirdCardValue==6 || cbPlayerThirdCardValue==7)) m_cbCardCount[INDEX_BANKER]++ ;
			break;

			//���벹��
		case 7:
		case 8:
		case 9:
			break;
		default:
			break;
		}
	}

	return true;
}

//ӯ���ж�
LONGLONG CTableFrameSink::AccountPayoffScore()
{
	//�������
	BYTE cbPlayerCount=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_PLAYER],m_cbCardCount[INDEX_PLAYER]);
	BYTE cbBankerCount=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_BANKER],m_cbCardCount[INDEX_BANKER]);

	//ӯ������
	LONGLONG lPayoffScore=0L;
	if (cbPlayerCount>cbBankerCount) lPayoffScore=m_lTieScore+m_lBankerScore-m_lPlayerScore;
	else if (cbPlayerCount<cbBankerCount) lPayoffScore=m_lTieScore+m_lPlayerScore-m_lBankerScore;
	else lPayoffScore=-m_lTieScore*8L;

	return lPayoffScore;
}

//����ׯ��
bool CTableFrameSink::OnUserApplyBanker( tagServerUserData *pUserData, bool bApplyBanker )
{
	//�Ϸ��ж�
	if ( bApplyBanker && pUserData->UserScoreInfo.lScore < m_lApplyBankerCondition ) return true;

	//�������
	if ( bApplyBanker )
	{
		//�����ж�
		for ( INT_PTR nUserIdx = 0; nUserIdx < m_ApplyUserArrary.GetCount(); ++nUserIdx )
		{
			tagApplyUserInfo ApplyUserInfo = m_ApplyUserArrary[ nUserIdx ];
			if ( ApplyUserInfo.dwUserID == pUserData->dwUserID ) return true;
		}

		//������Ϣ
		tagApplyUserInfo ApplyUserInfo;
		ApplyUserInfo.dwUserID = pUserData->dwUserID;
		ApplyUserInfo.lUserScore = pUserData->UserScoreInfo.lScore;
		ApplyUserInfo.wChairID = pUserData->wChairID;

		//�������
		INT_PTR nUserCount = m_ApplyUserArrary.GetCount();
		m_ApplyUserArrary.InsertAt( nUserCount, ApplyUserInfo );

		//�������
		CMD_S_ApplyBanker ApplyBanker;
		CopyMemory( ApplyBanker.szAccount, pUserData->szAccounts, sizeof( ApplyBanker.szAccount ) );
		ApplyBanker.lScore = pUserData->UserScoreInfo.lScore+pUserData->lStorageScore;
		ApplyBanker.bApplyBanker = true;

		//������Ϣ
		m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_APPLY_BANKER, &ApplyBanker, sizeof( ApplyBanker ) );
		m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_APPLY_BANKER, &ApplyBanker, sizeof( ApplyBanker ) );

		return true;
	}
	else	//ȡ������
	{
		//�����ж�
		for ( INT_PTR nUserIdx = 0; nUserIdx < m_ApplyUserArrary.GetCount(); ++nUserIdx )
		{
			tagApplyUserInfo ApplyUserInfo = m_ApplyUserArrary[ nUserIdx ];

			if ( ApplyUserInfo.dwUserID == pUserData->dwUserID )
			{
				//��ǰ�ж�
				if ( m_CurrentBanker.dwUserID == ApplyUserInfo.dwUserID )
				{
					m_bCancelBanker = true;
					continue;
				}

				//ɾ�����
				m_ApplyUserArrary.RemoveAt( nUserIdx );

				//�������
				CMD_S_ApplyBanker ApplyBanker;
				CopyMemory( ApplyBanker.szAccount, pUserData->szAccounts, sizeof( ApplyBanker.szAccount ) );
				ApplyBanker.lScore = pUserData->UserScoreInfo.lScore;
				ApplyBanker.bApplyBanker = false;

				//������Ϣ
				m_pITableFrame->SendTableData(INVALID_CHAIR, SUB_S_APPLY_BANKER, &ApplyBanker, sizeof( ApplyBanker ) );
				m_pITableFrame->SendLookonData(INVALID_CHAIR, SUB_S_APPLY_BANKER, &ApplyBanker, sizeof( ApplyBanker ) );

				return true;
			}
		}

		return true;
	}

	return true;

}

//����ׯ��
void CTableFrameSink::SendApplyUser( IServerUserItem *pRcvServerUserItem )
{
	for ( INT_PTR nUserIdx = 0; nUserIdx < m_ApplyUserArrary.GetCount(); ++nUserIdx )
	{
		tagApplyUserInfo ApplyUserInfo = m_ApplyUserArrary[ nUserIdx ];

		//��ȡ���
		IServerUserItem *pServerUserItem = m_pITableFrame->GetServerUserItem( ApplyUserInfo.wChairID );
		if ( ! pServerUserItem ) continue;

		//�������
		CMD_S_ApplyBanker ApplyBanker;
		CopyMemory( ApplyBanker.szAccount, pServerUserItem->GetAccounts(), sizeof( ApplyBanker.szAccount ) );
		ApplyBanker.lScore = pServerUserItem->GetUserScore()->lScore;
		ApplyBanker.bApplyBanker = true;

		//������Ϣ
		m_pITableFrame->SendUserData( pRcvServerUserItem, SUB_S_APPLY_BANKER, &ApplyBanker, sizeof( ApplyBanker ) );
	}
}

//����ׯ��
void CTableFrameSink::ChangeBanker()
{
	//��ȡ����
	TCHAR szPath[MAX_PATH]=TEXT("");
	GetCurrentDirectory(sizeof(szPath),szPath);

	//��ȡ����
	TCHAR szFileName[MAX_PATH];
	_snprintf(szFileName,sizeof(szFileName),TEXT("%s\\BaccaratConfig.ini"),szPath);

	//��ȡ����
	m_lApplyBankerCondition = GetPrivateProfileInt( TEXT("BankerCondition"), TEXT("Score"), 10000000, szFileName );
	m_lAreaLimitScore = GetPrivateProfileInt( TEXT("BankerCondition"), TEXT("AreaLimitScore"), 1000000000, szFileName );

	//��������
	m_cbBankerTimer++;

	//��ׯ�ж�
	if ( m_CurrentBanker.dwUserID != 0 )
	{
		//�ֻ��ж�
		bool bChangeBanker = false;
		IServerUserItem *pBankerUserItem = m_pITableFrame->GetServerUserItem(m_CurrentBanker.wChairID);
		LONG lBankerScore = pBankerUserItem->GetUserScore()->lScore+pBankerUserItem->GetUserData()->lStorageScore;
		for ( WORD wApplyUserIndex = 0; wApplyUserIndex < m_ApplyUserArrary.GetCount(); ++wApplyUserIndex )
		{
				tagApplyUserInfo &ApplyUserInfo = m_ApplyUserArrary[ wApplyUserIndex ];
				IServerUserItem *pApplyUserItem = m_pITableFrame->GetServerUserItem(ApplyUserInfo.wChairID);
				LONG lApplyUserScore = pApplyUserItem->GetUserScore()->lScore+pApplyUserItem->GetUserData()->lStorageScore;
				if ( lBankerScore < lApplyUserScore )
				{
					bChangeBanker = true;
					break;
				}
		}

		//�����ж�
		if ( bChangeBanker && 20 <= m_cbBankerTimer )
		{
			m_cbBankerTimer = 0;
			m_lBankerWinScore=0;
			m_bCancelBanker = false;

			//�ͻ���ɾ��
			IServerUserItem *pServerUserItem = m_pITableFrame->GetServerUserItem( m_CurrentBanker.wChairID );
			OnUserApplyBanker( pServerUserItem->GetUserData(), false ) ;

			//���¸�ֵ
			ZeroMemory( &m_CurrentBanker, sizeof( m_CurrentBanker ) );
			while( ! m_ApplyUserArrary.IsEmpty() )
			{
				m_CurrentBanker = m_ApplyUserArrary[ 0 ];
				//�Ϸ��ж�
				if ( m_CurrentBanker.lUserScore < m_lApplyBankerCondition )
				{
					ZeroMemory( &m_CurrentBanker, sizeof( m_CurrentBanker ) );

					//��ȡ���
					IServerUserItem *pServerUserItem = m_pITableFrame->GetServerUserItem( m_ApplyUserArrary[ 0 ].wChairID );
					if (  pServerUserItem  ) OnUserApplyBanker( pServerUserItem->GetUserData(), false );
				}
				else
					break;
			}
		}
	}
	else if ( 0 < m_ApplyUserArrary.GetCount() )
	{
		while( ! m_ApplyUserArrary.IsEmpty() )
		{
			m_CurrentBanker = m_ApplyUserArrary[ 0 ];
			//�Ϸ��ж�
			if ( m_CurrentBanker.lUserScore < m_lApplyBankerCondition )
			{
				ZeroMemory( &m_CurrentBanker, sizeof( m_CurrentBanker ) );
				//��ȡ���
				IServerUserItem *pServerUserItem = m_pITableFrame->GetServerUserItem( m_ApplyUserArrary[ 0 ].wChairID );
				if (  pServerUserItem  ) OnUserApplyBanker( pServerUserItem->GetUserData(), false );
			}
			else
				break;
		}
		m_cbBankerTimer = 0;
		m_lBankerWinScore=0;
		m_bCancelBanker = false;
	}
}

//�ֻ�ׯ��
void CTableFrameSink::SendChangeBankerMsg()
{
	CMD_S_ChangeBanker ChangeBanker;

	for ( WORD wChairID = 0; wChairID < GAME_PLAYER; ++wChairID )
	{
		IServerUserItem *pSeverUserItem = m_pITableFrame->GetServerUserItem( wChairID );
		if ( ! pSeverUserItem ) continue;

		ZeroMemory( &ChangeBanker, sizeof( ChangeBanker ) );
		if ( m_CurrentBanker.dwUserID != 0 )
		{
			ChangeBanker.wChairID = m_CurrentBanker.wChairID;
			ChangeBanker.lBankerTreasure = m_CurrentBanker.lUserScore;
		}
		else
		{
			ChangeBanker.wChairID = INVALID_CHAIR;
		}
		ChangeBanker.lBankerScore = m_CurrentBanker.lUserScore;
		ChangeBanker.cbBankerTime = m_cbBankerTimer;

		//�ҵ���ע
		m_pITableFrame->SendTableData( wChairID, SUB_S_CHANGE_BANKER, &ChangeBanker, sizeof( ChangeBanker ) );
		m_pITableFrame->SendLookonData( wChairID, SUB_S_CHANGE_BANKER, &ChangeBanker, sizeof( ChangeBanker ) );
	}
}

//�û�����
bool __cdecl CTableFrameSink::OnActionUserOffLine(WORD wChairID, IServerUserItem * pIServerUserItem) 
{
	return true;
}

//�����ע
LONG CTableFrameSink::GetMaxPlayerScore(WORD wChairID)
{
	//��������
	LONG lOtherAreaScore = m_lBankerScore+ m_lTieScore+ m_lTieSamePointScore+ m_lBankerKingScore;

	IServerUserItem *pServerUserItem = m_pITableFrame->GetServerUserItem(wChairID);

	//�����ע
	LONG lMaxPlayerScore = m_CurrentBanker.lUserScore+lOtherAreaScore;
	lMaxPlayerScore -= (m_lPlayerScore+m_lPlayerKingScore*2);

	//����ע��
	LONG lNowJetton = 0;
	lNowJetton += m_lUserPlayerScore[wChairID];
	lNowJetton += m_lUserPlayerKingScore[wChairID];
	lNowJetton += m_lUserBankerScore[wChairID];
	lNowJetton += m_lUserTieScore[wChairID];
	lNowJetton += m_lUserTieSamePointScore[wChairID];
	lNowJetton += m_lUserBankerKingScore[wChairID];

	//�ҵ���ע
	LONG lMeLessScore = pServerUserItem->GetUserScore()->lScore - lNowJetton;
	ASSERT(lMeLessScore >= 0 );
	lMeLessScore = max(lMeLessScore, 0);

	//�����ע
	LONG lMaxJetton = min(lMaxPlayerScore, lMeLessScore);
	LONG lAreaLimit = m_lAreaLimitScore - m_lPlayerScore;
	lMaxJetton = min(lMaxJetton, lAreaLimit);

	return lMaxJetton;
}

//�����ע
LONG CTableFrameSink::GetMaxPlayerKingScore(WORD wChairID)
{
	//��������
	LONG lOtherAreaScore = m_lBankerScore+ m_lTieScore+ m_lTieSamePointScore+ m_lBankerKingScore;

	IServerUserItem *pServerUserItem = m_pITableFrame->GetServerUserItem(wChairID);

	//�����ע
	LONG lMaxPlayerScore = m_CurrentBanker.lUserScore+lOtherAreaScore;
	lMaxPlayerScore -= (m_lPlayerScore+m_lPlayerKingScore*2);

	//����ע��
	LONG lNowJetton = 0;
	lNowJetton += m_lUserPlayerScore[wChairID];
	lNowJetton += m_lUserPlayerKingScore[wChairID];
	lNowJetton += m_lUserBankerScore[wChairID];
	lNowJetton += m_lUserTieScore[wChairID];
	lNowJetton += m_lUserTieSamePointScore[wChairID];
	lNowJetton += m_lUserBankerKingScore[wChairID];

	//�ҵ���ע
	LONG lMeLessScore = pServerUserItem->GetUserScore()->lScore - lNowJetton;
	ASSERT(lMeLessScore >= 0 );
	lMeLessScore = max(lMeLessScore, 0);

	//�����ע
	LONG lMaxJetton = min(lMaxPlayerScore/2, lMeLessScore);
	LONG lAreaLimit = m_lAreaLimitScore - m_lPlayerKingScore;
	lMaxJetton = min(lMaxJetton, lAreaLimit);

	return lMaxJetton;
}

//�����ע
LONG CTableFrameSink::GetMaxBankerScore(WORD wChairID)
{
	//��������
	LONG lOtherAreaScore = m_lPlayerScore + m_lPlayerKingScore + m_lTieSamePointScore+ m_lTieScore;

	IServerUserItem *pServerUserItem = m_pITableFrame->GetServerUserItem(wChairID);

	//�����ע
	LONG lMaxPlayerScore = lOtherAreaScore + m_CurrentBanker.lUserScore;
	lMaxPlayerScore -= (m_lBankerScore+m_lBankerKingScore*2);

	//����ע��
	LONG lNowJetton = 0;
	lNowJetton += m_lUserPlayerScore[wChairID];
	lNowJetton += m_lUserPlayerKingScore[wChairID];
	lNowJetton += m_lUserBankerScore[wChairID];
	lNowJetton += m_lUserTieScore[wChairID];
	lNowJetton += m_lUserTieSamePointScore[wChairID];
	lNowJetton += m_lUserBankerKingScore[wChairID];

	//�ҵ���ע
	LONG lMeLessScore = pServerUserItem->GetUserScore()->lScore - lNowJetton;
	ASSERT(lMeLessScore >= 0 );
	lMeLessScore = max(lMeLessScore, 0);

	//�����ע
	LONG lMaxJetton = min(lMaxPlayerScore, lMeLessScore);
	LONG lAreaLimit = m_lAreaLimitScore - m_lBankerScore;
	lMaxJetton = min(lMaxJetton, lAreaLimit);

	return lMaxJetton;
}

//�����ע
LONG CTableFrameSink::GetMaxBankerKingScore(WORD wChairID)
{
	//��������
	LONG lOtherAreaScore = m_lPlayerScore + m_lPlayerKingScore + m_lTieSamePointScore+ m_lTieScore;

	IServerUserItem *pServerUserItem = m_pITableFrame->GetServerUserItem(wChairID);

	//�����ע
	LONG lMaxPlayerScore = lOtherAreaScore + m_CurrentBanker.lUserScore;
	lMaxPlayerScore -= (m_lBankerScore+m_lBankerKingScore*2);

	//����ע��
	LONG lNowJetton = 0;
	lNowJetton += m_lUserPlayerScore[wChairID];
	lNowJetton += m_lUserPlayerKingScore[wChairID];
	lNowJetton += m_lUserBankerScore[wChairID];
	lNowJetton += m_lUserTieScore[wChairID];
	lNowJetton += m_lUserTieSamePointScore[wChairID];
	lNowJetton += m_lUserBankerKingScore[wChairID];

	//�ҵ���ע
	LONG lMeLessScore = pServerUserItem->GetUserScore()->lScore - lNowJetton;
	ASSERT(lMeLessScore >= 0 );
	lMeLessScore = max(lMeLessScore, 0);

	//�����ע
	LONG lMaxJetton = min(lMaxPlayerScore/2, lMeLessScore);
	LONG lAreaLimit = m_lAreaLimitScore - m_lBankerKingScore;
	lMaxJetton = min(lMaxJetton, lAreaLimit);

	return lMaxJetton;
}

//�����ע
LONG CTableFrameSink::GetMaxTieScore(WORD wChairID)
{
	IServerUserItem *pServerUserItem = m_pITableFrame->GetServerUserItem(wChairID);

	//�����ע
	LONG lMaxTieScore = m_CurrentBanker.lUserScore;
	lMaxTieScore -= (m_lTieScore * 8 + m_lTieSamePointScore * 33);

	//����ע��
	LONG lNowJetton = 0;
	lNowJetton += m_lUserPlayerScore[wChairID];
	lNowJetton += m_lUserPlayerKingScore[wChairID];
	lNowJetton += m_lUserBankerScore[wChairID];
	lNowJetton += m_lUserTieScore[wChairID];
	lNowJetton += m_lUserTieSamePointScore[wChairID];
	lNowJetton += m_lUserBankerKingScore[wChairID];

	//�ҵ���ע
	LONG lMeLessScore = pServerUserItem->GetUserScore()->lScore - lNowJetton;
	ASSERT(lMeLessScore >= 0 );
	lMeLessScore = max(lMeLessScore, 0);

	//�����ע
	LONG lMaxJetton = min(lMaxTieScore/8, lMeLessScore);
	LONG lAreaLimit = m_lAreaLimitScore - m_lTieScore;
	lMaxJetton = min(lMaxJetton, lAreaLimit);

	return lMaxJetton;
}

//�����ע
LONG CTableFrameSink::GetMaxTieKingScore(WORD wChairID)
{
	IServerUserItem *pServerUserItem = m_pITableFrame->GetServerUserItem(wChairID);

	//�����ע
	LONG lMaxTieScore = m_CurrentBanker.lUserScore;
	lMaxTieScore -= (m_lTieScore * 8 + m_lTieSamePointScore * 33);

	//����ע��
	LONG lNowJetton = 0;
	lNowJetton += m_lUserPlayerScore[wChairID];
	lNowJetton += m_lUserPlayerKingScore[wChairID];
	lNowJetton += m_lUserBankerScore[wChairID];
	lNowJetton += m_lUserTieScore[wChairID];
	lNowJetton += m_lUserTieSamePointScore[wChairID];
	lNowJetton += m_lUserBankerKingScore[wChairID];

	//�ҵ���ע
	LONG lMeLessScore = pServerUserItem->GetUserScore()->lScore - lNowJetton;
	ASSERT(lMeLessScore >= 0 );
	lMeLessScore = max(lMeLessScore, 0);

	//�����ע
	LONG lMaxJetton = min(lMaxTieScore/33, lMeLessScore);
	LONG lAreaLimit = m_lAreaLimitScore - m_lTieSamePointScore;
	lMaxJetton = min(lMaxJetton, lAreaLimit);

	return lMaxJetton;
}

//����÷�
void CTableFrameSink::CalculateScore()
{
	//������Ϣ
	CMD_S_GameScore GameScore;
	ZeroMemory(&GameScore,sizeof(GameScore));

	//��������
	LONG cbRevenue=m_pGameServiceOption->wRevenue;

	//�����Ƶ�
	BYTE cbPlayerCount=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_PLAYER],m_cbCardCount[INDEX_PLAYER]);
	BYTE cbBankerCount=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_BANKER],m_cbCardCount[INDEX_BANKER]);

	//�ƶ����
	DeduceWinner(GameScore.cbWinner, GameScore.cbKingWinner);

	//��Ϸ��¼
	tagServerGameRecord &GameRecord = m_GameRecordArrary[m_nRecordLast];
	GameRecord.cbBankerCount = cbBankerCount;
	GameRecord.cbPlayerCount = cbPlayerCount;
	GameRecord.lBankerScore = m_lBankerScore;
	GameRecord.lPlayerScore = m_lPlayerScore;
	GameRecord.lTieScore = m_lTieScore;
	GameRecord.wWinner = GameScore.cbWinner;

	//�ƶ��±�
	m_nRecordLast = (m_nRecordLast+1) % MAX_SCORE_HISTORY;
	if ( m_nRecordLast == m_nRecordFirst ) m_nRecordFirst = (m_nRecordFirst+1) % MAX_SCORE_HISTORY;

	//ׯ������
	LONG lBankerWinScore = 0;

	//��ҳɼ�
	ZeroMemory(m_lUserWinScore, sizeof(m_lUserWinScore));
	ZeroMemory(m_lUserReturnScore, sizeof(m_lUserReturnScore));
	ZeroMemory(m_lUserRevenue, sizeof(m_lUserRevenue));
	LONG lUserLostScore[GAME_PLAYER];
	ZeroMemory(lUserLostScore, sizeof(lUserLostScore));

	//�����ע
	LONG *pUserScore[] = {NULL, m_lUserPlayerScore, m_lUserTieScore, m_lUserBankerScore, m_lUserPlayerKingScore, 
		m_lUserBankerKingScore, m_lUserTieSamePointScore};
	//������
	BYTE cbMultiple[] = {0, 1, 8, 1, 2, 2, 33};

	//�������
	for (WORD i=0;i<GAME_PLAYER;i++)
	{
		//ׯ���ж�
		if ( m_CurrentBanker.dwUserID != 0 && m_CurrentBanker.wChairID == i ) continue;

		//��ȡ�û�
		IServerUserItem * pIServerUserItem=m_pITableFrame->GetServerUserItem(i);
		if (pIServerUserItem==NULL) continue;

		for ( WORD wAreaIndex = ID_XIAN_JIA; wAreaIndex <= ID_TONG_DIAN_PING; ++wAreaIndex )
		{
			if ( wAreaIndex == GameScore.cbWinner || wAreaIndex == GameScore.cbKingWinner ) 
			{
				m_lUserWinScore[i] += ( pUserScore[wAreaIndex][i] * cbMultiple[wAreaIndex] ) ;
				m_lUserReturnScore[i] += pUserScore[wAreaIndex][i] ;
				lBankerWinScore -= ( pUserScore[wAreaIndex][i] * cbMultiple[wAreaIndex] ) ;
			}
			else if ( GameScore.cbWinner == ID_PING_JIA )
			{
				m_lUserReturnScore[i] += pUserScore[wAreaIndex][i] ;
			}
			else
			{
				lUserLostScore[i] -= pUserScore[wAreaIndex][i] ;
				lBankerWinScore += pUserScore[wAreaIndex][i] ;
			}
		}

		//����˰��
		if ( 0 < m_lUserWinScore[i] )
		{
			m_lUserRevenue[i]  = m_lUserWinScore[i]*cbRevenue/100L;
			m_lUserWinScore[i] -= m_lUserRevenue[i];
		}

		//�ܵķ���
		m_lUserWinScore[i] += lUserLostScore[i];
	}

	//ׯ�ҳɼ�
	if ( m_CurrentBanker.dwUserID != 0 )
	{
		WORD wBankerChairID = m_CurrentBanker.wChairID;
		m_lUserWinScore[wBankerChairID] = lBankerWinScore;

		//����˰��
		if ( 0 < m_lUserWinScore[wBankerChairID] )
		{
			m_lUserRevenue[wBankerChairID]  = m_lUserWinScore[wBankerChairID]*cbRevenue/100L;
			m_lUserWinScore[wBankerChairID] -= m_lUserRevenue[wBankerChairID];
			lBankerWinScore = m_lUserWinScore[wBankerChairID];
		}
		IServerUserItem *pBankerUserItem = m_pITableFrame->GetServerUserItem(wBankerChairID);

		//�ۼƻ���
		m_lBankerWinScore += lBankerWinScore;
	}

	//��ע����
	GameScore.lDrawTieScore=m_lTieScore;
	GameScore.lDrawBankerScore=m_lBankerScore;
	GameScore.lDrawPlayerScore=m_lPlayerScore;
	GameScore.lDrawTieSamPointScore = m_lTieSamePointScore;
	GameScore.lDrawBankerKingScore = m_lBankerKingScore;
	GameScore.lDrawPlayerKingScore = m_lPlayerKingScore;

	GameScore.lBankerScore = lBankerWinScore;

	//���ͻ���
	for ( WORD wUserIndex = 0; wUserIndex < GAME_PLAYER; ++wUserIndex )
	{
		IServerUserItem *pIServerUserItem = m_pITableFrame->GetServerUserItem(wUserIndex);
		if ( pIServerUserItem == NULL ) continue;

		//�ҵ���ע
		GameScore.lMeTieScore=m_lUserTieScore[wUserIndex];
		GameScore.lMeBankerScore=m_lUserBankerScore[wUserIndex];
		GameScore.lMePlayerScore=m_lUserPlayerScore[wUserIndex];
		GameScore.lMeTieKingScore = m_lUserTieSamePointScore[wUserIndex];
		GameScore.lMeBankerKingScore = m_lUserBankerKingScore[wUserIndex];
		GameScore.lMePlayerKingScore = m_lUserPlayerKingScore[wUserIndex];

		//������Ϣ
		GameScore.lMeGameScore=m_lUserWinScore[wUserIndex];
		GameScore.lMeReturnScore = m_lUserReturnScore[wUserIndex];
		m_pITableFrame->SendTableData(wUserIndex,SUB_S_GAME_SCORE,&GameScore,sizeof(GameScore));
		m_pITableFrame->SendLookonData(wUserIndex,SUB_S_GAME_SCORE,&GameScore,sizeof(GameScore));
	}
	return ;
}

//�ƶ�Ӯ��
void CTableFrameSink::DeduceWinner(BYTE &cbWinner, BYTE &cbKingWinner)
{
	cbWinner = 0;
	cbKingWinner = 0;

	//�����Ƶ�
	BYTE cbPlayerCount=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_PLAYER],m_cbCardCount[INDEX_PLAYER]);
	BYTE cbBankerCount=m_GameLogic.GetCardListPip(m_cbTableCardArray[INDEX_BANKER],m_cbCardCount[INDEX_BANKER]);

	//ʤ�����
	if (cbPlayerCount==cbBankerCount)
	{
		cbWinner=ID_PING_JIA;

		//ͬ��ƽ�ж�
		bool bAllPointSame = false;
		if ( m_cbCardCount[INDEX_PLAYER] == m_cbCardCount[INDEX_BANKER] )
		{
			for (WORD wCardIndex = 0; wCardIndex < m_cbCardCount[INDEX_PLAYER]; ++wCardIndex )
			{
				BYTE cbBankerValue = m_GameLogic.GetCardValue(m_cbTableCardArray[INDEX_BANKER][wCardIndex]);
				BYTE cbPlayerValue = m_GameLogic.GetCardValue(m_cbTableCardArray[INDEX_PLAYER][wCardIndex]);
				if ( cbBankerValue != cbPlayerValue ) break;
			}
			if ( wCardIndex == m_cbCardCount[INDEX_PLAYER] ) bAllPointSame = true;
		}
		if ( bAllPointSame ) cbKingWinner = ID_TONG_DIAN_PING;
	}
	else if (cbPlayerCount<cbBankerCount) 
	{
		cbWinner=ID_ZHUANG_JIA;

		//�����ж�
		if ( cbBankerCount == 8 || cbBankerCount == 9 ) cbKingWinner = ID_ZHUANG_TIAN_WANG;
	}
	else 
	{
		cbWinner=ID_XIAN_JIA;

		//�����ж�
		if ( cbPlayerCount == 8 || cbPlayerCount == 9 ) cbKingWinner = ID_XIAN_TIAN_WANG;
	}
}
//////////////////////////////////////////////////////////////////////////

